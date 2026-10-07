# Changelog

## 2.0.1 (2026-10-07)

- When YouTube refuses a download (HTTP 403, bot check, reload page, nsig failure), `process_video.sh` now names the fix, `brew upgrade yt-dlp`, and shows the installed version. Other download failures keep a generic message. Tests in `tests/test_download_hint.sh`.
- Add `examples/agentic-venture-os/`, real output from a 3-minute product demo.

## 2.0.0 (2026-10-07)

Renamed from **video-to-prd** to **video-to-spec**. The output is now a spec-driven development specification instead of a PRD.

- Output is `spec.md` following the Spec Kit spec template (house preset): How to read this, prioritized user stories with independent tests, EARS `FR-` and `NFR-` requirements, an edge-case table, `SC-` success criteria, Assumptions, and a Clarifications table with `[NEEDS CLARIFICATION: C-n]` markers.
- Screen-by-screen UI detail, the inferred data model with field evidence, and stack hints move to a sibling `ui-evidence.md`.
- In a repository with `.specify/`, output lands in `specs/NNN-<short-name>/`, uses the repository's resolved spec template, and updates `.specify/feature.json`. Elsewhere it lands in `./spec-<short-name>/`.
- New `scripts/spec_target.sh` with tests in `tests/test_spec_target.sh`.
- No em dashes in generated output.
- Breaking: the skill and plugin are now `video-to-spec`; `PRD-<slug>.md` is no longer written.

## 1.1.0

Last release as video-to-prd: dependency preflight, fixes from adversarial review.
