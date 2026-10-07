# Feature Specification: video-to-spec 2.0.0

**Created**: 2026-10-07

**Status**: Accepted (scope approved by Vj on 2026-10-07)

**Input**: "Update video-to-prd from PRD output to a spec for spec-driven development, rename the repo to video-to-spec, keep screen-by-screen UI detail in a sibling file."

## How to read this

**The one idea**: A screen recording is a better input to `/speckit-specify` than a typed description, so the skill should produce the same `spec.md` Spec Kit would, plus the visual evidence a spec has no room for.

**What this spec covers**: The output document format, where it is written, the hand-off to the Spec Kit flow, and the rename from video-to-prd to video-to-spec (plugin, skill, repo, catalog entries).

**What it deliberately leaves out**: The video pipeline (download, scene detection, frame selection, transcription) is unchanged. Creating git branches is left to the user or to Spec Kit's `before_specify` hook. Generating `plan.md` or `tasks.md` is out of scope.

**The spec-driven caveat**: This is a contract change to a published plugin, so it gets a spec. It specifies behavior, not the wording of SKILL.md.

## Requirements

### Functional Requirements

- **FR-001**: The skill shall produce a spec whose section order and headings match `sdd-preset/templates/spec-template.md` (How to read this, User Scenarios & Testing, Edge Cases with table, Requirements with FR and NFR, Key Entities, Success Criteria, Assumptions, Clarifications).
- **FR-002**: The skill shall write every functional and non-functional requirement in one of the five EARS patterns, with `FR-nnn` or `NFR-nnn` ids, and cite at least one `(video MM:SS)` timestamp and an Observed or Inferred tag per requirement.
- **FR-003**: The skill shall express each demonstrated user flow as a prioritized user story with an independent test and Given/When/Then acceptance scenarios.
- **FR-004**: The skill shall mark each unknown inline as `[NEEDS CLARIFICATION: C-n]` and give every marker a row in the Clarifications table with options and a recommended default.
- **FR-005**: The skill shall write a sibling `ui-evidence.md` holding the screen-by-screen UI specification, the inferred data model with field evidence, and any stack hints, and the spec shall reference it.
- **FR-006**: WHERE the current git repository contains `.specify/`, the skill shall write to `specs/<prefix>-<short-name>/spec.md` using the repository's numbering mode, resolve the spec template through the repository's override stack, and record the directory in `.specify/feature.json`.
- **FR-007**: IF the current directory has no `.specify/`, THEN the skill shall write `spec-<slug>/spec.md` and `spec-<slug>/ui-evidence.md` in the current directory using the bundled template, and offer `/sdd-init`.
- **FR-008**: WHEN delivery completes, the skill shall name `/speckit-clarify` then `/speckit-plan` as the next steps.
- **FR-009**: The plugin, skill, marketplace entries, README, and scripts shall use the name `video-to-spec`, and the plugin version shall be 2.0.0.

### Non-functional Requirements

- **NFR-001**: The skill shall emit no em dash characters (U+2014) in any generated file.
- **NFR-002**: IF a target spec directory already contains `spec.md`, THEN the skill shall not overwrite it and shall pick the next number instead.

## Success Criteria

- **SC-001**: `grep -c $'\xe2\x80\x94'` returns 0 for SKILL.md, both templates, and README.
- **SC-002**: The target-resolution script returns the correct path in three fixtures: no `.specify/`, `.specify/` with sequential numbering and an existing `001-*`, and `.specify/` with timestamp numbering.
- **SC-003**: `grep -ri "video-to-prd"` over the repo returns only the changelog and migration note.

## Clarifications

| Id | Decision | Options | Recommended default | Lands in |
|----|----------|---------|---------------------|----------|
| C-1 | New name | video-to-spec · demo-to-spec · video-to-speckit | DECIDED: video-to-spec | FR-009 |
| C-2 | Home for screen-by-screen UI detail | sibling file · appendix in spec.md | DECIDED: sibling `ui-evidence.md` | FR-005 |
| C-3 | Cap on clarification markers (core Spec Kit caps at 3; house rule marks every unknown) | cap at 3 · no cap | DECIDED: no cap for scope, security, and UX-shaping unknowns; low-impact defaults go to Assumptions, stated explicitly | FR-004 |

## Traceability

| Task | Requirement |
|------|-------------|
| Rewrite `references/spec-template.md` | FR-001 to FR-004, NFR-001 |
| Add `references/ui-evidence-template.md` | FR-005 |
| Add `scripts/spec_target.sh` and `tests/test_spec_target.sh` | FR-006, FR-007, NFR-002, SC-002 |
| Rewrite SKILL.md steps 4 and 5 | FR-002 to FR-008 |
| Rename across plugin, README, scripts, tinkery | FR-009, SC-003 |
