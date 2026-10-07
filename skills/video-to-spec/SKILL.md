---
name: video-to-spec
description: Convert a screen-recording video (local file in any format, or a YouTube link) into a spec-driven development specification, the same spec.md that /speckit-specify writes, plus a ui-evidence.md with the screen-by-screen detail. Extracts the narration as a transcript, captures screenshots at screen changes, analyzes both together, and writes EARS requirements, prioritized user stories, success criteria, and a clarifications table, ready for /speckit-clarify and /speckit-plan. Use when the user wants to turn a product demo, screen recording, walkthrough video, or YouTube demo into a spec, specification, Spec Kit feature, PRD, or requirements document.
---

# video-to-spec

Turn a screen-recording demo into a spec-driven development specification.

**Input:** `$ARGUMENTS`: a local video file path or a YouTube URL. If neither
is provided, ask the user for one before doing anything else.

All helper scripts live in this skill's `scripts/` directory (resolve the
absolute path of this SKILL.md's directory first; call it `$SKILL_DIR`).

Never use em dashes in anything you write: use a comma, a colon, a period, or
parentheses.

## Step 0: Preflight the toolchain

Run the dependency check once before anything else:

```bash
bash "$SKILL_DIR/scripts/check_deps.sh"
```

Exit 0 means everything needed is present: continue. Exit 1 means something
is missing; the output lists exactly what, split into **required** (`ffmpeg`,
`python3`, `curl`) and **optional-per-path** (`yt-dlp` only for URLs,
`whisper-cpp` only for caption-less videos; note a URL input can still need
whisper-cpp if the video turns out to have no captions, which you'll know
after Step 1 from `meta.txt`).

If required tools, or the optional tool for this input (yt-dlp for a URL,
whisper-cpp for a local video that may lack narration), are missing, **show
the user the list and ask whether to install them**, naming the exact command
(`brew install ...`). Do not install without a clear yes. On approval, run
`--install` naming exactly the packages the user approved:

```bash
bash "$SKILL_DIR/scripts/check_deps.sh" --install <approved-packages...>
```

which installs only those via Homebrew and re-verifies (bare `--install`
installs only the missing *required* set, never optional tools). If Homebrew
isn't present (or the user is on Linux), the report already printed the right
manual command: relay it and let the user install, rather than proceeding to a
step that will fail.

## Step 1: Process the video

Pick a work directory `$WORK` (use the session scratchpad if available,
otherwise `mktemp -d`), then run:

```bash
bash "$SKILL_DIR/scripts/process_video.sh" "<input>" "$WORK"
```

This downloads the video if it's a URL (1080p max, high enough that dense
dashboard text stays legible, plus YouTube captions when available), extracts
16kHz audio when no captions exist, and detects screen changes to produce
timestamped keyframes in `$WORK/frames/` (`frame_MMmSSs.png`). Selection
guarantees coverage across the whole timeline (so a busy tail can't starve a
content-rich intro), caps frames per time-bucket, drops near-duplicates, and
offsets each capture past the transition so frames land on the settled screen
rather than a motion-blurred crossfade. Read `$WORK/meta.txt` for duration,
frame count, and whether captions and an audio stream were found. If it says
`captions: no` and `whisper-cli` was reported missing in Step 0, pause here
and get approval to install `whisper-cpp` before Step 2, since transcription
will need it.

If the script fails, show the user the error. Common causes are a missing
dependency (it names the `brew install` fix), a private or region-locked
YouTube video, or an unreadable file.

## Step 2: Get the transcript

```bash
bash "$SKILL_DIR/scripts/transcribe.sh" "$WORK"
```

Uses the downloaded captions when present; otherwise transcribes locally with
whisper.cpp (downloads the ~466MB small model once to `~/.cache/whisper-cpp/`;
tell the user before this first-time download happens and that it is
one-time). Output: `$WORK/transcript.txt` with `[MM:SS] text` lines.

If transcription reports the video has no narration, tell the user the spec
will be built from visuals alone and will have more inferred content and more
clarifications.

## Step 3: Analyze transcript and screenshots together

1. Read `$WORK/transcript.txt` in full.
2. List `$WORK/frames/` and read the screenshots with the Read tool. Read
   them in timestamp order, several per batch. If there are more than 30,
   sample evenly across the timeline but always include the first and last.
3. For each screenshot, pair it with the transcript lines within ~10 seconds
   of its timestamp: the narration usually explains exactly what is on
   screen at that moment.
4. Watch for **sparse or blurry stretches**: if a span of the timeline has few
   frames, or a frame is a motion-blurred transition, say so and reconstruct
   that stretch from the transcript rather than guessing, and route what you
   can't verify to a clarification.
5. Reading **small text** (dashboard figures, tiny labels) off a frame is
   error-prone. When a number or label is not clearly legible, mark it as a
   lower-confidence read (Inferred, or Observed with an "approximate, read
   from a small thumbnail" note) rather than asserting it as hard Observed.

While reading, build a working map (jot it as notes if helpful):
- **Flows:** the sequences of actions demonstrated. Each becomes a user
  story; rank them, P1 being the core loop the demo exists to show.
- **Behaviors:** everything shown or narrated, including features mentioned
  but not shown on screen. Each becomes an EARS requirement.
- **Screens:** each distinct screen or view, its layout, and components.
- **Data:** entities and fields implied by what the UI displays.
- **Edges:** empty, loading, and error states seen or implied.
- **Gaps:** anything ambiguous, contradictory, or off-screen.

Do not skip screenshots: screens that appear without narration still belong
in ui-evidence.md.

**Classify the demo type**, since it changes how much to trust the narration:
- **Working-app recording:** a real cursor drives a real UI; you can see
  clicks, loading states, typed input, and consistent chrome across frames.
  Treat what happens on screen as ground truth.
- **Scripted promo / vision reel:** polished motion graphics, voiceover-led,
  cuts that skip the actual interaction, claims like "instantly" or "a fleet
  of 100 agents." Much of the narration is aspirational marketing, not
  demonstrated behavior.

Decide which one this is; it is stated in both output files.

## Step 4: Write the spec and the UI evidence

1. Pick a 2 to 4 word kebab-case short name from the product or feature as
   identified in the video (not the filename), e.g. `kanban-board`. Then run:

   ```bash
   bash "$SKILL_DIR/scripts/spec_target.sh" <short-name> "$PWD"
   ```

   It prints `mode`, `feature_dir`, `spec_file`, `ui_file`, and `template`,
   and creates the directory. In a Spec Kit repository (`mode=speckit`) this
   mirrors `/speckit-specify`: `specs/NNN-<short-name>/` using the repo's
   numbering mode, the repo's own resolved spec template (overrides win), and
   `.specify/feature.json` pointing at the new directory so `/speckit-plan`
   finds it. Elsewhere (`mode=standalone`) it uses `./spec-<short-name>/` and
   the bundled template. It never reuses a directory that already has a
   spec.md. It does not create a git branch: that stays the user's call (or
   their `before_specify` hook).

2. Read `$SKILL_DIR/references/writing-rules.md` and the template at the
   printed `template` path. If `.specify/memory/constitution.md` exists, read
   it too and respect its articles.

3. Write `spec_file` following the template's section order and headings
   exactly, filled per the writing rules. Set `Input` to the video source and
   duration. In "How to read this", state the demo type and point to
   `ui-evidence.md` for screen detail.

4. Write `ui_file` from `$SKILL_DIR/references/ui-evidence-template.md`.

5. Run the writing rules' quality checklist against both files and fix any
   misses, including:

   ```bash
   grep -n $'\xe2\x80\x94' "<spec_file>" "<ui_file>"
   ```

   which must print nothing.

## Step 5: Deliver

Tell the user:
- Where the two files were written, and whether this was a Spec Kit repo
  (with the feature number) or a standalone folder.
- A 3 to 5 bullet summary of what the spec covers.
- Counts: user stories, FRs, NFRs, SCs, screens, clarifications.
- The clarifications that matter most, with their recommended defaults.
- Next steps: `/speckit-clarify` to settle the C-n rows, then `/speckit-plan`
  (which reads ui-evidence.md alongside the spec). In standalone mode, offer
  `/sdd-init` first, then move the folder to `specs/001-<short-name>/`.
- That the work directory (`$WORK`) holds the transcript and screenshots if
  they want to inspect them.
