# Video to PRD

`video-to-prd` is a personal Codex skill that turns product demos, founder walkthroughs, launch videos, and screen recordings into evidence-backed product requirements documents.

It reviews the full video, extracts or transcribes narration, captures precise product frames, maps observed and inferred behavior, and produces an implementation-grade PRD with testable requirements.

## What it produces

```text
<output-directory>/
├── PRODUCT_PRD.md
├── EVIDENCE_NOTES.md
└── screenshots/
    ├── 01-descriptive-product-state.png
    └── ...
```

The PRD workflow covers:

- product vision and target users;
- end-to-end workflows and object lifecycles;
- prioritized functional requirements and acceptance criteria;
- AI orchestration, evidence, approvals, audit, and safety;
- non-functional requirements and canonical data entities;
- success metrics, instrumentation, risks, phases, and launch gates;
- time-coded source evidence and verified screenshots.

## Install with Codex

Ask Codex:

```text
Use $skill-installer to install the video-to-prd skill from https://github.com/vjanma/video-to-prd/tree/main/skills/video-to-prd
```

## Manual installation

```bash
git clone https://github.com/vjanma/video-to-prd.git
mkdir -p ~/.codex/skills
cp -R video-to-prd/skills/video-to-prd ~/.codex/skills/
```

Start a new Codex task after installation so the personal skill catalog refreshes.

## Usage

```text
Use $video-to-prd to analyze this product video, capture key product screenshots, and create a detailed evidence-backed PRD: [VIDEO URL OR LOCAL PATH]
```

Optional context can include the product name, intended PRD audience, output directory, desired depth, and preferred screenshot count.

## Media-tool support

The skill can use browser inspection and available platform captions. Its bundled extraction helper additionally supports:

- Python 3.10 or newer;
- `ffmpeg` and `ffprobe` for media processing;
- `yt-dlp` for supported video URLs;
- `whisper-cli` plus a local GGML Whisper model when captions are unavailable.

The helper scripts use only the Python standard library. Optional media commands are discovered at runtime and fail with clear dependency messages.

## Repository layout

```text
skills/video-to-prd/
├── SKILL.md
├── agents/openai.yaml
├── references/
│   ├── evidence-rules.md
│   └── prd-schema.md
└── scripts/
    ├── extract_video_evidence.py
    └── validate_deliverables.py
```

The skill keeps its main instructions concise and loads the detailed evidence and PRD references only when triggered.

## Validation

The repository checks:

- skill frontmatter and interface metadata;
- relative skill references;
- Python syntax;
- exact frame extraction from a generated test video;
- PRD headings, requirement IDs, image references, image integrity, resolution, and duplicate frames.

Run locally:

```bash
python3 -m pip install PyYAML
python3 scripts/validate_skill.py
python3 scripts/smoke_test.py
```
