#!/usr/bin/env python3
"""Prepare video evidence, exact product frames, and optional local transcript."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from urllib.parse import urlparse


def command_path(name: str, required: bool = True) -> str | None:
    path = shutil.which(name)
    if required and not path:
        raise SystemExit(f"Required command not found: {name}")
    return path


def run(command: list[str], *, check: bool = True, capture: bool = False) -> subprocess.CompletedProcess[str]:
    rendered = " ".join(command[:3]) + (" …" if len(command) > 3 else "")
    print(f"[video-to-prd] {rendered}", file=sys.stderr)
    return subprocess.run(
        command,
        check=check,
        text=True,
        stdout=subprocess.PIPE if capture else subprocess.DEVNULL,
        stderr=subprocess.PIPE if capture else None,
    )


def is_url(value: str) -> bool:
    return urlparse(value).scheme.lower() in {"http", "https"}


def parse_time(value: str) -> float:
    value = value.strip()
    if re.fullmatch(r"\d+(?:\.\d+)?", value):
        return float(value)
    parts = value.split(":")
    if len(parts) not in {2, 3}:
        raise argparse.ArgumentTypeError(f"Invalid timestamp: {value}")
    try:
        numbers = [float(part) for part in parts]
    except ValueError as exc:
        raise argparse.ArgumentTypeError(f"Invalid timestamp: {value}") from exc
    if len(numbers) == 2:
        minutes, seconds = numbers
        return minutes * 60 + seconds
    hours, minutes, seconds = numbers
    return hours * 3600 + minutes * 60 + seconds


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", value.strip().lower()).strip("-")
    return slug or "frame"


def parse_frame(value: str) -> tuple[float, str, str]:
    if "=" not in value:
        raise argparse.ArgumentTypeError("Frame must use TIMESTAMP=descriptive-name")
    timestamp, name = value.split("=", 1)
    return parse_time(timestamp), slugify(name), timestamp.strip()


def probe_media(ffprobe: str, path: Path) -> dict[str, object]:
    result = run(
        [
            ffprobe,
            "-v",
            "error",
            "-select_streams",
            "v:0",
            "-show_entries",
            "format=duration:stream=width,height,codec_name",
            "-of",
            "json",
            str(path),
        ],
        capture=True,
    )
    payload = json.loads(result.stdout or "{}")
    stream = (payload.get("streams") or [{}])[0]
    format_data = payload.get("format") or {}
    return {
        "duration_seconds": float(format_data.get("duration", 0) or 0),
        "width": int(stream.get("width", 0) or 0),
        "height": int(stream.get("height", 0) or 0),
        "video_codec": stream.get("codec_name"),
    }


def fetch_metadata(yt_dlp: str, source: str) -> dict[str, object]:
    result = run(
        [yt_dlp, "--no-update", "--skip-download", "--dump-single-json", source],
        capture=True,
    )
    raw = json.loads(result.stdout)
    return {
        "id": raw.get("id"),
        "title": raw.get("title"),
        "creator": raw.get("channel") or raw.get("uploader"),
        "duration_seconds": raw.get("duration"),
        "description": raw.get("description"),
        "webpage_url": raw.get("webpage_url") or source,
    }


def download_captions(yt_dlp: str, source: str, work_dir: Path, language: str) -> list[Path]:
    template = str(work_dir / "captions.%(ext)s")
    run(
        [
            yt_dlp,
            "--no-update",
            "--skip-download",
            "--write-subs",
            "--write-auto-subs",
            "--sub-langs",
            f"{language}.*,{language}",
            "--sub-format",
            "vtt",
            "-o",
            template,
            source,
        ],
        check=False,
    )
    return sorted(work_dir.glob("captions*.vtt"))


def download_video(yt_dlp: str, source: str, work_dir: Path, max_height: int) -> Path:
    template = str(work_dir / "source.%(ext)s")
    result = run(
        [
            yt_dlp,
            "--no-update",
            "-f",
            f"bv*[height<={max_height}]+ba/b[height<={max_height}]",
            "--merge-output-format",
            "mp4",
            "--print",
            "after_move:filepath",
            "-o",
            template,
            source,
        ],
        capture=True,
    )
    candidates = [Path(line.strip()) for line in result.stdout.splitlines() if line.strip()]
    for candidate in reversed(candidates):
        if candidate.exists():
            return candidate
    media = [
        path
        for path in work_dir.glob("source.*")
        if path.suffix.lower() not in {".json", ".vtt", ".srt", ".txt", ".wav"}
    ]
    if not media:
        raise SystemExit("Video download completed without a discoverable media file")
    return max(media, key=lambda path: path.stat().st_size)


def extract_audio(ffmpeg: str, video: Path, work_dir: Path) -> Path:
    audio = work_dir / "audio-16khz-mono.wav"
    run(
        [
            ffmpeg,
            "-hide_banner",
            "-loglevel",
            "error",
            "-y",
            "-i",
            str(video),
            "-vn",
            "-ar",
            "16000",
            "-ac",
            "1",
            "-c:a",
            "pcm_s16le",
            str(audio),
        ]
    )
    return audio


def transcribe(
    whisper_cli: str,
    model: Path,
    audio: Path,
    work_dir: Path,
    language: str,
    prompt: str,
    threads: int,
) -> list[Path]:
    output_base = work_dir / "transcript"
    command = [
        whisper_cli,
        "-m",
        str(model),
        "-l",
        language,
        "-f",
        str(audio),
        "-of",
        str(output_base),
        "-otxt",
        "-osrt",
        "-oj",
        "-t",
        str(threads),
    ]
    if prompt:
        command.extend(["--prompt", prompt])
    run(command)
    return [path for path in [output_base.with_suffix(".txt"), output_base.with_suffix(".srt"), output_base.with_suffix(".json")] if path.exists()]


def capture_frame(ffmpeg: str, video: Path, seconds: float, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    run(
        [
            ffmpeg,
            "-hide_banner",
            "-loglevel",
            "error",
            "-y",
            "-i",
            str(video),
            "-vf",
            f"select=gte(t\\,{seconds:.3f})",
            "-frames:v",
            "1",
            str(destination),
        ]
    )
    if not destination.exists() or destination.stat().st_size == 0:
        raise SystemExit(f"Failed to capture frame at {seconds:.3f}s")


def create_storyboard(ffmpeg: str, video: Path, destination: Path, interval: float, width: int) -> int:
    destination.mkdir(parents=True, exist_ok=True)
    for old in destination.glob("storyboard_*.jpg"):
        old.unlink()
    run(
        [
            ffmpeg,
            "-hide_banner",
            "-loglevel",
            "error",
            "-y",
            "-i",
            str(video),
            "-vf",
            f"fps=1/{interval},scale={width}:-2",
            "-q:v",
            "3",
            str(destination / "storyboard_%03d.jpg"),
        ]
    )
    return len(list(destination.glob("storyboard_*.jpg")))


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", help="HTTP(S) video URL or local video path")
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--work-dir", type=Path, help="Default: <output-dir>/.video-to-prd-work")
    parser.add_argument("--frame", action="append", default=[], type=parse_frame, metavar="TIME=NAME")
    parser.add_argument("--storyboard-interval", type=float, default=0, metavar="SECONDS")
    parser.add_argument("--storyboard-width", type=int, default=360)
    parser.add_argument("--max-height", type=int, default=1080)
    parser.add_argument("--language", default="en")
    parser.add_argument("--no-captions", action="store_true")
    parser.add_argument("--whisper-model", type=Path, default=os.environ.get("WHISPER_MODEL"))
    parser.add_argument("--whisper-prompt", default="")
    parser.add_argument("--threads", type=int, default=max(1, min(8, os.cpu_count() or 4)))
    parser.add_argument("--remove-media", action="store_true", help="Delete downloaded video and extracted WAV after processing")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    if args.storyboard_interval < 0:
        raise SystemExit("--storyboard-interval must be zero or positive")

    ffmpeg = command_path("ffmpeg")
    ffprobe = command_path("ffprobe")
    yt_dlp = command_path("yt-dlp", required=is_url(args.source))

    output_dir = args.output_dir.expanduser().resolve()
    work_dir = (args.work_dir or output_dir / ".video-to-prd-work").expanduser().resolve()
    screenshots_dir = output_dir / "screenshots"
    storyboard_dir = output_dir / "storyboard"
    output_dir.mkdir(parents=True, exist_ok=True)
    work_dir.mkdir(parents=True, exist_ok=True)

    source_metadata: dict[str, object]
    captions: list[Path] = []
    downloaded = False
    if is_url(args.source):
        assert yt_dlp is not None
        source_metadata = fetch_metadata(yt_dlp, args.source)
        if not args.no_captions:
            captions = download_captions(yt_dlp, args.source, work_dir, args.language)
        video = download_video(yt_dlp, args.source, work_dir, args.max_height)
        downloaded = True
    else:
        video = Path(args.source).expanduser().resolve()
        if not video.is_file():
            raise SystemExit(f"Video file not found: {video}")
        source_metadata = {"title": video.stem, "webpage_url": None}

    media_metadata = probe_media(ffprobe, video)
    duration = float(media_metadata["duration_seconds"] or 0)
    frames_manifest: list[dict[str, object]] = []
    for index, (seconds, name, original_time) in enumerate(args.frame, start=1):
        if duration and seconds > duration:
            raise SystemExit(f"Frame {original_time} exceeds video duration {duration:.3f}s")
        destination = screenshots_dir / f"{index:02d}-{name}.png"
        capture_frame(ffmpeg, video, seconds, destination)
        image_metadata = probe_media(ffprobe, destination)
        frames_manifest.append(
            {
                "timestamp": original_time,
                "seconds": seconds,
                "name": name,
                "path": str(destination),
                "width": image_metadata["width"],
                "height": image_metadata["height"],
            }
        )

    storyboard_count = 0
    if args.storyboard_interval:
        storyboard_count = create_storyboard(
            ffmpeg,
            video,
            storyboard_dir,
            args.storyboard_interval,
            args.storyboard_width,
        )

    transcript_paths: list[Path] = []
    audio: Path | None = None
    transcript_method = "captions" if captions else "none"
    model_value = args.whisper_model
    model = Path(model_value).expanduser().resolve() if model_value else None
    if not captions and model:
        if not model.is_file():
            raise SystemExit(f"Whisper model not found: {model}")
        whisper_cli = command_path("whisper-cli")
        audio = extract_audio(ffmpeg, video, work_dir)
        transcript_paths = transcribe(
            whisper_cli,
            model,
            audio,
            work_dir,
            args.language,
            args.whisper_prompt,
            args.threads,
        )
        transcript_method = "local-whisper"

    if args.remove_media:
        if downloaded and video.is_file():
            video.unlink()
        if audio and audio.is_file():
            audio.unlink()

    manifest = {
        "source": args.source,
        "source_metadata": source_metadata,
        "media_metadata": media_metadata,
        "working_video": str(video) if video.exists() else None,
        "transcript_method": transcript_method,
        "caption_files": [str(path) for path in captions],
        "transcript_files": [str(path) for path in transcript_paths],
        "storyboard_directory": str(storyboard_dir) if storyboard_count else None,
        "storyboard_count": storyboard_count,
        "frames": frames_manifest,
        "cleanup_note": f"Remove {work_dir} and {storyboard_dir} after evidence synthesis unless the user requested intermediate files.",
    }
    manifest_path = work_dir / "evidence_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({"manifest": str(manifest_path), **manifest}, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
