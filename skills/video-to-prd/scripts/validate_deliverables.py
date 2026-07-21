#!/usr/bin/env python3
"""Validate a video-derived PRD, evidence notes, and screenshot set."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
from collections import Counter
from pathlib import Path
from urllib.parse import unquote


IMAGE_PATTERN = re.compile(r"!\[[^\]]*\]\(([^)]+)\)")
REQUIREMENT_PATTERN = re.compile(r"\|\s*([A-Z][A-Z0-9]*-\d{2,})\s*\|")
PLACEHOLDER_PATTERN = re.compile(r"\[(?:VIDEO_URL_OR_PATH|PRODUCT_NAME_OR_UNKNOWN|OUTPUT_DIRECTORY)\]|\bTODO\b", re.IGNORECASE)

REQUIRED_HEADINGS = {
    "executive summary": ("executive summary",),
    "product vision": ("product vision", "vision"),
    "problem definition": ("problem definition", "problem statement", "user problem"),
    "goals and non-goals": ("goals and non-goals", "goals", "non-goals"),
    "target users": ("target users", "personas", "users and jobs"),
    "functional requirements": ("functional requirements", "requirements"),
    "non-functional requirements": ("non-functional requirements", "quality attributes"),
    "success metrics": ("success metrics", "product metrics", "north-star metric"),
    "risks": ("risks",),
    "open decisions": ("open product decisions", "open questions", "open decisions"),
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def resolve_image_reference(prd: Path, raw: str) -> Path | None:
    value = raw.strip().strip("<>")
    if value.startswith(("http://", "https://", "data:")):
        return None
    value = unquote(value.split("#", 1)[0])
    candidate = Path(value)
    return candidate if candidate.is_absolute() else (prd.parent / candidate).resolve()


def image_metadata(ffprobe: str, path: Path) -> tuple[int, int]:
    result = subprocess.run(
        [
            ffprobe,
            "-v",
            "error",
            "-select_streams",
            "v:0",
            "-show_entries",
            "stream=width,height",
            "-of",
            "json",
            str(path),
        ],
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if result.returncode != 0:
        raise ValueError(result.stderr.strip() or "ffprobe could not read image")
    payload = json.loads(result.stdout or "{}")
    stream = (payload.get("streams") or [{}])[0]
    return int(stream.get("width", 0) or 0), int(stream.get("height", 0) or 0)


def headings(markdown: str) -> list[str]:
    return [match.group(1).strip().lower() for match in re.finditer(r"^#{1,6}\s+(.+?)\s*$", markdown, re.MULTILINE)]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prd", required=True, type=Path)
    parser.add_argument("--evidence", type=Path)
    parser.add_argument("--screenshots", required=True, type=Path)
    parser.add_argument("--min-screenshots", type=int, default=5)
    parser.add_argument("--min-width", type=int, default=640)
    parser.add_argument("--min-height", type=int, default=360)
    args = parser.parse_args()

    errors: list[str] = []
    warnings: list[str] = []
    prd = args.prd.expanduser().resolve()
    screenshots_dir = args.screenshots.expanduser().resolve()

    if not prd.is_file():
        errors.append(f"PRD not found: {prd}")
        markdown = ""
    else:
        markdown = prd.read_text(encoding="utf-8")

    if args.evidence and not args.evidence.expanduser().resolve().is_file():
        errors.append(f"Evidence notes not found: {args.evidence.expanduser().resolve()}")

    if not screenshots_dir.is_dir():
        errors.append(f"Screenshot directory not found: {screenshots_dir}")
        screenshots: list[Path] = []
    else:
        screenshots = sorted(
            path for path in screenshots_dir.iterdir() if path.suffix.lower() in {".png", ".jpg", ".jpeg", ".webp"}
        )

    if len(screenshots) < args.min_screenshots:
        warnings.append(f"Only {len(screenshots)} screenshots found; expected at least {args.min_screenshots}")

    if markdown:
        found_headings = headings(markdown)
        for label, alternatives in REQUIRED_HEADINGS.items():
            if not any(any(alt in heading for alt in alternatives) for heading in found_headings):
                errors.append(f"Missing required PRD section: {label}")

        if PLACEHOLDER_PATTERN.search(markdown):
            errors.append("PRD contains unresolved prompt placeholders or TODO markers")

        requirement_ids = REQUIREMENT_PATTERN.findall(markdown)
        duplicates = sorted(item for item, count in Counter(requirement_ids).items() if count > 1)
        if duplicates:
            errors.append("Duplicate requirement IDs: " + ", ".join(duplicates))
        if not requirement_ids:
            warnings.append("No table-form requirement IDs were detected")

        references = IMAGE_PATTERN.findall(markdown)
        local_references = [path for raw in references if (path := resolve_image_reference(prd, raw)) is not None]
        for path in local_references:
            if not path.is_file():
                errors.append(f"Referenced image missing: {path}")
        if not local_references:
            warnings.append("PRD does not embed any local screenshots")

        referenced_resolved = {path.resolve() for path in local_references if path.exists()}
        unreferenced = [path.name for path in screenshots if path.resolve() not in referenced_resolved]
        if unreferenced:
            warnings.append("Screenshots not referenced in PRD: " + ", ".join(unreferenced))

    ffprobe = shutil.which("ffprobe")
    hashes: dict[str, list[str]] = {}
    for screenshot in screenshots:
        hashes.setdefault(sha256(screenshot), []).append(screenshot.name)
        if screenshot.stat().st_size == 0:
            errors.append(f"Empty screenshot: {screenshot}")
            continue
        if ffprobe:
            try:
                width, height = image_metadata(ffprobe, screenshot)
            except ValueError as exc:
                errors.append(f"Unreadable screenshot {screenshot.name}: {exc}")
                continue
            if width < args.min_width or height < args.min_height:
                warnings.append(
                    f"Low-resolution screenshot {screenshot.name}: {width}x{height}; recommended minimum {args.min_width}x{args.min_height}"
                )
        else:
            warnings.append("ffprobe unavailable; skipped screenshot dimension and decode checks")
            break

    duplicate_images = [names for names in hashes.values() if len(names) > 1]
    for names in duplicate_images:
        errors.append("Exact duplicate screenshots: " + ", ".join(names))

    report = {
        "prd": str(prd),
        "screenshots": len(screenshots),
        "requirements": len(REQUIREMENT_PATTERN.findall(markdown)),
        "errors": errors,
        "warnings": warnings,
    }
    print(json.dumps(report, indent=2))
    if errors:
        print(f"Validation failed with {len(errors)} error(s)", file=sys.stderr)
        return 1
    print(f"Validation passed with {len(warnings)} warning(s)", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
