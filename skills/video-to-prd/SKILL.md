---
name: video-to-prd
description: Analyze product demo videos, founder walkthroughs, launch videos, and screen recordings using complete visual review, transcript extraction or local transcription, precise key-frame capture, evidence mapping, and implementation-grade PRD generation. Use when a user supplies a video URL or local video and asks to understand product vision, reconstruct workflows, capture representative product screenshots, compare visible features, or create requirements and specifications from the recording.
---

# Video to PRD

Turn a product video into an evidence-backed PRD, time-coded evidence notes, and a verified screenshot set. Treat the video as a system demonstration rather than a collection of screens.

## Output contract

Unless the user requests another format, create:

```text
<output-directory>/
├── PRODUCT_PRD.md
├── EVIDENCE_NOTES.md
└── screenshots/
    ├── 01-descriptive-state.png
    └── ...
```

Default to 10–15 screenshots for a short product demo. Scale the count to the number of distinct product states, not video length alone. Do not retain downloaded source video, extracted audio, model files, storyboards, or full transcripts in the deliverable directory unless requested.

## Required references

Read both references completely before analysis or writing:

- [references/evidence-rules.md](references/evidence-rules.md) for transcript, screenshot, uncertainty, and evidence-labeling rules.
- [references/prd-schema.md](references/prd-schema.md) for the required PRD structure and requirement quality bar.

## Workflow

### 1. Establish scope and source access

Identify the video URL/path, output directory, intended audience, product name if known, desired depth, and requested output format. Make reasonable defaults when optional inputs are absent.

Inspect the actual video from beginning to end. Do not rely on the title, description, thumbnail, transcript alone, or a few sampled frames. Record source title, creator/channel, duration, access date, and important product terminology.

Use the best available lawful access path:

1. Prefer a purpose-built connector, API, or CLI for metadata or captions when available.
2. Use the applicable browser-control skill when visual or interactive page inspection is needed.
3. Use local media tools for exact frame extraction and audio transcription after access is established.

If authentication blocks the requested source, ask the user to sign in on the selected surface. Do not bypass access restrictions.

### 2. Obtain narration evidence

Prefer, in order:

1. creator-provided captions;
2. platform-generated captions;
3. local speech-to-text from extracted audio.

If captions are unavailable, continue with local transcription when tools permit. Reconcile product names and domain terms against visible UI. Mark unresolved words, figures, or names as uncertain. Do not present machine transcription as exact.

Do not reproduce a full transcript unless explicitly requested. Create time-coded paraphrased evidence notes instead.

### 3. Build a time-coded evidence map

Cover the full narrative and each meaningful product-state transition. For every segment, capture:

- timestamp range;
- narration-derived meaning;
- visible product state;
- product implication;
- uncertainty or confidence when needed.

Label statements as **Observed**, **Inferred**, or **Recommended** according to the evidence rules. Never present inferred or recommended behavior as demonstrated functionality.

### 4. Select and capture product frames

Create a storyboard or sample frames every 3–8 seconds to orient to the video. Then capture exact high-resolution frames for the strongest states. Prefer stable frames with readable UI and no video-player controls.

Use the bundled extractor when local media tools are available:

```bash
python3 scripts/extract_video_evidence.py \
  <video-url-or-path> \
  --output-dir <temporary-evidence-directory> \
  --storyboard-interval 5 \
  --frame '00:00:10=executive-dashboard' \
  --frame '00:00:42=concept-exploration'
```

For local transcription fallback, add `--whisper-model <path-to-ggml-model>` or set `WHISPER_MODEL`. The script keeps downloaded media and audio in temporary storage by default and returns a manifest describing evidence paths.

Use exact frame extraction that decodes preceding interframes; avoid fast-seek-only captures that may return an earlier keyframe, black blocks, or transition corruption. Verify every selected image visually.

Name screenshots sequentially and descriptively. Record each screenshot's approximate timestamp and what it proves in `EVIDENCE_NOTES.md`.

### 5. Synthesize the product as a system

Identify the product promise, target users, core objects, lifecycle, data flow, AI/automation layer, human approval points, generated artifacts, integrations, and measurable user outcome. Distinguish product modules from generated exports and external tools.

Model downstream consistency explicitly: when a decision changes, determine which analytics, tasks, artifacts, decks, or financial assumptions should become stale or update.

### 6. Write the PRD

Follow `references/prd-schema.md`. Make the document useful to product, design, engineering, data/AI, security, and business stakeholders.

At minimum:

- embed relevant screenshots near the requirements they support;
- assign unique requirement IDs;
- prioritize each requirement as P0, P1, or P2;
- provide testable acceptance criteria;
- distinguish demonstrated functionality from production-critical inference;
- specify AI evidence, approval, audit, failure, cost, and safety behavior when applicable;
- define success metrics, non-functional requirements, risks, phases, launch criteria, and open decisions.

Avoid generic prose, invented market facts, false precision, and implementation choices unsupported by the user's context. Label proposed numeric targets as recommendations.

### 7. Validate and clean

Run the bundled validator:

```bash
python3 scripts/validate_deliverables.py \
  --prd <output-directory>/PRODUCT_PRD.md \
  --evidence <output-directory>/EVIDENCE_NOTES.md \
  --screenshots <output-directory>/screenshots
```

Fix all errors. Review warnings and resolve those that materially affect the deliverable. Visually inspect representative and borderline frames even when automated checks pass.

Remove temporary media, audio, storyboards, models, and redundant transcript files from the deliverable directory. Preserve only outputs requested by the user.

### 8. Deliver

Link the PRD, evidence notes, and screenshot directory. Summarize scope, requirement count, important assumptions, and source limitations. Render several representative screenshots inline in the final response; when the user asked for screenshots, do not return only file links.

## Failure handling

- If the source cannot be accessed, report the exact access blocker and the needed user action.
- If audio cannot be transcribed, continue with visual evidence and clearly state the narration limitation.
- If precise frame extraction is unavailable, use browser screenshots only after seeking to verified timestamps and checking each frame.
- If the video shows a prototype, describe it as demonstrated intent rather than confirmed production behavior.
- If product terminology remains ambiguous, omit it from binding requirements or mark it explicitly in evidence notes.
