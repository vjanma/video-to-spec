---
name: video-to-prd
description: Convert a screen-recording video (local file in any format, or a YouTube link) into an implementation-ready Product Requirements Document. Extracts the audio narration as a transcript, captures screenshots at screen changes, analyzes both together, and writes a best-practices PRD ready to hand to AI coding tools. Use when the user wants to turn a product demo, screen recording, walkthrough video, or YouTube demo into a PRD, spec, or requirements document.
---

# video-to-prd

Turn a screen-recording demo into a PRD an AI coding tool can implement.

**Input:** `$ARGUMENTS` — a local video file path or a YouTube URL. If neither
is provided, ask the user for one before doing anything else.

All helper scripts live in this skill's `scripts/` directory (resolve the
absolute path of this SKILL.md's directory first; call it `$SKILL_DIR`).

## Step 1 — Process the video

Pick a work directory `$WORK` (use the session scratchpad if available,
otherwise `mktemp -d`), then run:

```bash
bash $SKILL_DIR/scripts/process_video.sh "<input>" "$WORK"
```

This downloads the video if it's a URL (720p max, plus YouTube captions when
available), extracts 16kHz audio when no captions exist, and detects screen
changes to produce timestamped keyframes in `$WORK/frames/`
(`frame_MMmSSs.png`). It adapts automatically: low scene threshold for subtle
UI transitions, interval sampling if the screen barely changes, capped when
the video is busy. Read `$WORK/meta.txt` for duration, frame count, and
whether captions were found.

If the script fails, show the user the error — common causes are a missing
dependency (it names the `brew install` fix), a private/region-locked YouTube
video, or an unreadable file.

## Step 2 — Get the transcript

```bash
bash $SKILL_DIR/scripts/transcribe.sh "$WORK"
```

Uses the downloaded captions when present; otherwise transcribes locally with
whisper.cpp (downloads the ~466MB small model once to `~/.cache/whisper-cpp/`
— tell the user before this first-time download happens and that it is
one-time). Output: `$WORK/transcript.txt` with `[MM:SS] text` lines.

If transcription reports the video has no narration, tell the user the PRD
will be built from visuals alone and will have more inferred content.

## Step 3 — Analyze transcript + screenshots together

1. Read `$WORK/transcript.txt` in full.
2. List `$WORK/frames/` and read the screenshots with the Read tool. Read
   them in timestamp order, several per batch. If there are more than 30,
   sample evenly across the timeline but always include the first and last.
3. For each screenshot, pair it with the transcript lines within ~10 seconds
   of its timestamp — the narration usually explains exactly what is on
   screen at that moment.

While reading, build a working map (jot it as notes if helpful):
- **Screens:** each distinct screen/view, its layout, and visible components.
- **Flows:** the sequences of actions demonstrated (clicks, inputs, results).
- **Features:** everything narrated, including features mentioned but not
  shown on screen.
- **Data:** entities and fields implied by what the UI displays.
- **Gaps:** anything ambiguous, contradictory, or off-screen.

Do not skip screenshots: screens that appear without narration still belong
in the PRD.

## Step 4 — Write the PRD

Read `$SKILL_DIR/references/prd-template.md` and follow its structure and
writing rules exactly. Key rules: text-only (no embedded images), every
requirement cites video timestamps, observed vs. inferred is always marked,
no TBDs — ambiguities become Open Questions with recommended defaults.

Write the PRD to the user's current working directory as
`PRD-<product-slug>.md` (slug from the product's name as identified in the
video, not the filename). Run the template's quality-bar checklist against
your draft and fix any misses before delivering.

## Step 5 — Deliver

Tell the user:
- Where the PRD was written and a 3–5 bullet summary of the product it specifies.
- How many screens/features/requirements were captured.
- The top open questions they should resolve (or confirm the defaults) before
  handing the PRD to an implementation tool.
- That the work directory (`$WORK`) holds the transcript and screenshots if
  they want to inspect them.
