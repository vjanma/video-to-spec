# video-to-prd

A [Claude Code](https://claude.com/claude-code) skill that turns a **screen-recording video** — a local file in any format, or a **YouTube link** — into a high-quality, implementation-ready **Product Requirements Document**.

Point it at a product demo and it will:

1. **Download / ingest the video** (yt-dlp for YouTube, ffmpeg for any local format)
2. **Transcribe the narration** — free YouTube captions when available, otherwise local [whisper.cpp](https://github.com/ggerganov/whisper.cpp) transcription (Metal-accelerated on Apple Silicon, no API keys)
3. **Screenshot key moments** — ffmpeg scene detection tuned for screen recordings finds every screen change; falls back to interval sampling for mostly-static recordings
4. **Analyze both together** — Claude pairs each screenshot with the narration at that timestamp to understand screens, flows, features, and the implied data model
5. **Write the PRD** — a text-only markdown document following PRD best practices: timestamped requirement citations, testable acceptance criteria, screen-by-screen UI specs, inferred data model, and open questions with recommended defaults — ready to hand to Claude Code, Cursor, or any AI coding tool

## Requirements

- macOS or Linux with [Claude Code](https://claude.com/claude-code)
- `ffmpeg` — `brew install ffmpeg`
- `yt-dlp` (only for YouTube links) — `brew install yt-dlp`
- `whisper-cpp` (only for videos without captions) — `brew install whisper-cpp`
  - First transcription downloads the whisper `small` model (~466MB, one-time) to `~/.cache/whisper-cpp/`

## Install

**Option A — via the [tinkery](https://github.com/vjanma/tinkery) marketplace (recommended).** In any Claude Code session:

```
/plugin marketplace add vjanma/tinkery
/plugin install video-to-prd@tinkery
```

The skill is then invoked as `/video-to-prd:video-to-prd`, and updates arrive via `/plugin marketplace update tinkery`. (This repo also works as a standalone marketplace: `/plugin marketplace add vjanma/video-to-prd`.)

**Option B — clone + symlink (personal skill, un-namespaced).**

```bash
git clone https://github.com/vjanma/video-to-prd.git
ln -s "$(pwd)/video-to-prd/skills/video-to-prd" ~/.claude/skills/video-to-prd
```

This makes it available as plain `/video-to-prd`.

## Usage

In any Claude Code session:

```
/video-to-prd ~/Desktop/demo-recording.mov            (symlink install)
/video-to-prd:video-to-prd https://youtu.be/XXXXXXX   (plugin install)
```

Or just ask naturally: *"turn this screen recording into a PRD"*.

The PRD is written to your current directory as `PRD-<product-name>.md`.

## What the PRD contains

| Section | Content |
|---|---|
| Overview, Goals & Non-Goals | What the product is and what's explicitly out of scope |
| Functional Requirements | Numbered `FR-n` items, each with behavior, Given/When/Then acceptance criteria, and a `(video MM:SS)` citation |
| Screen-by-Screen UI Spec | Layout, components, states, and navigation for every screen seen |
| User Flows | End-to-end step sequences demonstrated in the video |
| Data Model | Entities and fields inferred from the UI, with evidence |
| Open Questions | Every ambiguity, each with a recommended default so implementation is never blocked |

Everything observed in the video is distinguished from everything inferred, and nothing requires watching the video to understand.

## How it works

```
video / URL
    │  scripts/process_video.sh   (yt-dlp + ffmpeg scene detection)
    ▼
frames/frame_MMmSSs.png  +  captions.vtt | audio.wav
    │  scripts/transcribe.sh      (clean_vtt.py | whisper-cli)
    ▼
transcript.txt  [MM:SS] lines
    │  Claude reads frames + transcript, pairs them by timestamp
    ▼
PRD-<product>.md          (references/prd-template.md structure)
```

## License

Apache 2.0
