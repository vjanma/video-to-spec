#!/usr/bin/env python3
"""Exercise exact frame extraction and deliverable validation."""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "skills/video-to-prd"


def run(command: list[str], *, stdout: int | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, check=True, text=True, stdout=stdout)


def main() -> int:
    for command in ("ffmpeg", "ffprobe"):
        if not shutil.which(command):
            raise SystemExit(f"Required smoke-test command not found: {command}")

    with tempfile.TemporaryDirectory(prefix="video-to-prd-smoke-") as raw_tmp:
        tmp = Path(raw_tmp)
        video = tmp / "source.mp4"
        output = tmp / "output"
        result = tmp / "result.json"

        run(
            [
                "ffmpeg",
                "-hide_banner",
                "-loglevel",
                "error",
                "-y",
                "-f",
                "lavfi",
                "-i",
                "color=c=red:s=640x360:d=1:r=30",
                "-f",
                "lavfi",
                "-i",
                "color=c=green:s=640x360:d=1:r=30",
                "-f",
                "lavfi",
                "-i",
                "color=c=blue:s=640x360:d=1:r=30",
                "-filter_complex",
                "[0:v][1:v][2:v]concat=n=3:v=1:a=0,format=yuv420p",
                str(video),
            ]
        )

        with result.open("w", encoding="utf-8") as handle:
            subprocess.run(
                [
                    sys.executable,
                    str(SKILL / "scripts/extract_video_evidence.py"),
                    str(video),
                    "--output-dir",
                    str(output),
                    "--storyboard-interval",
                    "1",
                    "--frame",
                    "00:00:00.2=red-state",
                    "--frame",
                    "00:00:01.2=green-state",
                    "--frame",
                    "00:00:02.2=blue-state",
                ],
                check=True,
                text=True,
                stdout=handle,
            )

        manifest = json.loads(result.read_text(encoding="utf-8"))
        assert manifest["storyboard_count"] == 3
        assert len(manifest["frames"]) == 3
        assert all((frame["width"], frame["height"]) == (640, 360) for frame in manifest["frames"])

        images = [Path(frame["path"]) for frame in manifest["frames"]]
        prd = output / "PRODUCT_PRD.md"
        evidence = output / "EVIDENCE_NOTES.md"
        image_markdown = "\n\n".join(f"![State {index}](screenshots/{path.name})" for index, path in enumerate(images, 1))
        prd.write_text(
            "\n".join(
                [
                    "# Synthetic Product PRD",
                    "",
                    "## Executive summary",
                    "Synthetic validation artifact.",
                    "## Product vision",
                    "Validate evidence extraction.",
                    "## Problem definition",
                    "Frame accuracy needs deterministic testing.",
                    "## Goals and non-goals",
                    "Validate the helpers; do not test interpretation.",
                    "## Target users",
                    "Skill maintainers.",
                    "## Functional requirements",
                    "| ID | Pri. | Requirement | Acceptance criteria |",
                    "|---|---:|---|---|",
                    "| TEST-01 | P0 | Capture exact frames. | Three unique frames exist. |",
                    "## Non-functional requirements",
                    "Frames are at least 640x360.",
                    "## Success metrics",
                    "All smoke checks pass.",
                    "## Risks",
                    "Interframe seeking can capture the wrong state.",
                    "## Open product decisions",
                    "None for the synthetic fixture.",
                    image_markdown,
                    "",
                ]
            ),
            encoding="utf-8",
        )
        evidence.write_text("# Evidence notes\n\nSynthetic three-state video.\n", encoding="utf-8")

        run(
            [
                sys.executable,
                str(SKILL / "scripts/validate_deliverables.py"),
                "--prd",
                str(prd),
                "--evidence",
                str(evidence),
                "--screenshots",
                str(output / "screenshots"),
                "--min-screenshots",
                "3",
            ]
        )

    print("Smoke test passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
