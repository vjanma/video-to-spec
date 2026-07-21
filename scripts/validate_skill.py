#!/usr/bin/env python3
"""Validate the public repository's installable Codex skill."""

from __future__ import annotations

import argparse
import py_compile
import re
import sys
from pathlib import Path

import yaml


REFERENCE_PATTERN = re.compile(r"\[[^\]]+\]\(([^)]+)\)")


def parse_frontmatter(path: Path) -> tuple[dict[str, object], str]:
    text = path.read_text(encoding="utf-8")
    match = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not match:
        raise ValueError("SKILL.md must begin with YAML frontmatter")
    metadata = yaml.safe_load(match.group(1))
    if not isinstance(metadata, dict):
        raise ValueError("SKILL.md frontmatter must be a mapping")
    return metadata, text


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("skill", nargs="?", type=Path, default=Path("skills/video-to-prd"))
    args = parser.parse_args()
    skill = args.skill.resolve()
    errors: list[str] = []

    required = [
        skill / "SKILL.md",
        skill / "agents/openai.yaml",
        skill / "references/evidence-rules.md",
        skill / "references/prd-schema.md",
        skill / "scripts/extract_video_evidence.py",
        skill / "scripts/validate_deliverables.py",
    ]
    for path in required:
        if not path.is_file():
            errors.append(f"Missing required file: {path}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    try:
        metadata, skill_text = parse_frontmatter(skill / "SKILL.md")
    except (OSError, ValueError, yaml.YAMLError) as exc:
        errors.append(str(exc))
        metadata, skill_text = {}, ""

    if set(metadata) != {"name", "description"}:
        errors.append("SKILL.md frontmatter must contain only name and description")
    if metadata.get("name") != skill.name:
        errors.append(f"Skill name must match folder name: {skill.name}")
    description = metadata.get("description")
    if not isinstance(description, str) or len(description.strip()) < 40:
        errors.append("Skill description must clearly describe behavior and triggers")
    if re.search(r"\bTODO\b|\[TODO", skill_text, re.IGNORECASE):
        errors.append("SKILL.md contains unresolved TODO content")
    if len(skill_text.splitlines()) > 500:
        errors.append("SKILL.md exceeds the 500-line progressive-disclosure limit")

    for raw in REFERENCE_PATTERN.findall(skill_text):
        value = raw.strip().strip("<>").split("#", 1)[0]
        if not value or value.startswith(("http://", "https://")):
            continue
        path = (skill / value).resolve()
        try:
            path.relative_to(skill)
        except ValueError:
            errors.append(f"Skill reference escapes the skill folder: {raw}")
            continue
        if not path.exists():
            errors.append(f"Broken skill reference: {raw}")

    try:
        interface = yaml.safe_load((skill / "agents/openai.yaml").read_text(encoding="utf-8"))
        values = interface.get("interface", {}) if isinstance(interface, dict) else {}
        for field in ("display_name", "short_description", "default_prompt"):
            if not isinstance(values.get(field), str) or not values[field].strip():
                errors.append(f"agents/openai.yaml missing interface.{field}")
        if "$video-to-prd" not in str(values.get("default_prompt", "")):
            errors.append("interface.default_prompt must mention $video-to-prd")
    except (OSError, yaml.YAMLError) as exc:
        errors.append(f"Invalid agents/openai.yaml: {exc}")

    for script in (skill / "scripts").glob("*.py"):
        try:
            py_compile.compile(str(script), doraise=True)
        except py_compile.PyCompileError as exc:
            errors.append(f"Python syntax error in {script.name}: {exc.msg}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print(f"Skill is valid: {skill}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
