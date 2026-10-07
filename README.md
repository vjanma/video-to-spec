# video-to-spec

A [Claude Code](https://claude.com/claude-code) skill that turns a **screen-recording video** (a local file in any format, or a **YouTube link**) into a **spec-driven development specification**: the same `spec.md` that [Spec Kit](https://github.com/github/spec-kit)'s `/speckit-specify` writes, plus a sibling `ui-evidence.md` with everything the recording showed that a spec has no room for.

A demo is a better input to a spec than a typed description: it shows the flows, the screens, the states, and the narrator's intent. Point it at one and it will:

1. **Download or ingest the video** (yt-dlp for YouTube, ffmpeg for any local format)
2. **Transcribe the narration**: free YouTube captions when available, otherwise local [whisper.cpp](https://github.com/ggerganov/whisper.cpp) transcription (Metal-accelerated on Apple Silicon, no API keys)
3. **Screenshot key moments**: ffmpeg scene detection tuned for screen recordings finds every screen change, and frame selection guarantees coverage across the whole timeline, even for mostly static recordings
4. **Analyze both together**: Claude pairs each screenshot with the narration at that timestamp to understand flows, behaviors, screens, states, and the implied data
5. **Write the spec**: prioritized user stories, EARS requirements with timestamp citations, an edge-case table, measurable success criteria, and a clarifications table with a recommended default for every unknown, ready for `/speckit-clarify` and `/speckit-plan`

## Requirements

- macOS or Linux with [Claude Code](https://claude.com/claude-code)
- `ffmpeg` (includes `ffprobe`): `brew install ffmpeg`
- `python3` and `curl`: preinstalled on most systems
- `yt-dlp` (only for YouTube links): `brew install yt-dlp`
- `whisper-cpp` (only for videos without captions): `brew install whisper-cpp`
  - First transcription downloads the whisper `small` model (~466MB, one-time) to `~/.cache/whisper-cpp/`
- Optional: [Spec Kit](https://github.com/github/spec-kit) in the target repository, so the spec lands in `specs/NNN-name/`

The skill **preflights these for you**: before processing, it runs
`scripts/check_deps.sh`, reports anything missing in one pass, and (with your
say-so) installs the missing tools via Homebrew (`check_deps.sh --install`).
On Linux or without Homebrew it prints the exact manual command instead. You can
also run the check yourself:

```bash
bash skills/video-to-spec/scripts/check_deps.sh
```

## Install

**Option A: via the [tinkery](https://github.com/vjanma/tinkery) marketplace (recommended).** In any Claude Code session:

```
/plugin marketplace add vjanma/tinkery
/plugin install video-to-spec@tinkery
```

The skill is then invoked as `/video-to-spec:video-to-spec`, and updates arrive via `/plugin marketplace update tinkery`. If the skill isn't visible right after installing, start a new Claude Code session. (This repo also works as a standalone marketplace: `/plugin marketplace add vjanma/video-to-spec`.)

**Option B: clone and symlink (personal skill, un-namespaced).**

```bash
git clone https://github.com/vjanma/video-to-spec.git
mkdir -p ~/.claude/skills
ln -s "$(pwd)/video-to-spec/skills/video-to-spec" ~/.claude/skills/video-to-spec
```

This makes it available as plain `/video-to-spec`.

## Usage

In any Claude Code session, from the repository the spec is for:

```
/video-to-spec ~/Desktop/demo-recording.mov              (symlink install)
/video-to-spec:video-to-spec https://youtu.be/XXXXXXX    (plugin install)
```

Or just ask naturally: *"turn this screen recording into a spec"*.

**Where it writes:**

| Where you run it | Output | Template used |
|---|---|---|
| A repository with `.specify/` | `specs/NNN-<short-name>/spec.md` and `ui-evidence.md`, numbered like `/speckit-specify` (sequential or timestamp, per `.specify/init-options.json`), with `.specify/feature.json` pointing at it | The repository's own resolved `spec-template` (project overrides win) |
| Anywhere else | `./spec-<short-name>/spec.md` and `ui-evidence.md` | The bundled template |

It never overwrites an existing `spec.md`, and it does not create a git branch.

**Then:** `/speckit-clarify` to settle the clarifications, `/speckit-plan` to plan (it reads `ui-evidence.md` alongside the spec). No Spec Kit yet? Run `specify init --here --integration claude` first, then move the folder to `specs/001-<short-name>/`.

## What it writes

**`spec.md`** follows the spec template's sections exactly:

| Section | Content from the video |
|---|---|
| How to read this | The one idea, what the spec covers and leaves out, and whether the video is a working-app recording or a scripted promo |
| User Scenarios & Testing | One prioritized user story per demonstrated flow, each with an independent test and Given/When/Then scenarios citing `(video MM:SS)` |
| Edge Cases | Empty, loading, and error states seen or implied, each mapped to a requirement id |
| Functional and Non-functional Requirements | `FR-nnn` and `NFR-nnn` in EARS form, each with a timestamp citation and an Observed or Inferred tag |
| Key Entities | Entities the UI implies, with meaning and relationships |
| Success Criteria | `SC-nnn`, measurable and technology-agnostic |
| Assumptions | Low-impact defaults, stated rather than silent |
| Clarifications | Every `[NEEDS CLARIFICATION: C-n]` with options and a recommended default |

**`ui-evidence.md`** holds what the spec deliberately leaves out: a screen-by-screen UI specification (layout, components, states, navigation), step-by-step flows, the inferred data model with field-level evidence, implementation hints if the video reveals any, and coverage notes.

Narration-only claims in a promo video are never written up as demonstrated behavior, and nothing requires watching the video to understand.

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
    │  scripts/spec_target.sh     (Spec Kit target dir + template)
    ▼
specs/NNN-<name>/spec.md + ui-evidence.md
```

## Development

```bash
bash tests/test_spec_target.sh
```

The change spec for 2.0.0 is in [docs/spec-2.0.0.md](docs/spec-2.0.0.md). The bundled `references/spec-template.md` is a copy of the personal preset template; re-sync it when the preset changes.

## Migrating from video-to-prd

This project was called **video-to-prd** until 2.0.0. The old GitHub URL redirects here. If you installed it from tinkery:

```
/plugin uninstall video-to-prd@tinkery
/plugin marketplace update tinkery
/plugin install video-to-spec@tinkery
```

If you symlinked it, replace `~/.claude/skills/video-to-prd` with a link to `skills/video-to-spec`. See [CHANGELOG.md](CHANGELOG.md) for what changed.

## License

Apache 2.0
