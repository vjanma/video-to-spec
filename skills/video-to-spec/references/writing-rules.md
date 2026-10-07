# Writing a spec from a video

The spec you produce is the input to `/speckit-clarify` and `/speckit-plan`.
Nobody downstream will watch the video, so everything they need must be in
`spec.md` and `ui-evidence.md`, in unambiguous prose.

Follow the **section order and headings of the resolved spec template**
exactly (the path comes from `spec_target.sh`). This file adds the rules for
filling it from a recording. Never use em dashes anywhere: use a comma, a
colon, a period, or parentheses.

## Writing rules

1. **Ground every claim in the video.** Every FR, NFR, acceptance scenario,
   and edge case cites the timestamp(s) where it was shown or narrated, e.g.
   `(video 02:14)`. Never invent features that were neither shown nor said.
2. **Observed vs. inferred, always marked.** End each requirement with
   `Source: Observed` or `Source: Inferred (<one-line rationale>)`. UI seen in
   frames and behavior the narrator described are Observed. Validation rules,
   data shapes, and behavior you deduced are Inferred.
3. **EARS, one pattern per requirement.** Ubiquitous ("The system shall"),
   Event-driven ("WHEN ..., the system shall"), State-driven ("WHILE ...,
   the system shall"), Unwanted behavior ("IF ..., THEN the system shall"),
   Optional feature ("WHERE ..., the system shall"). One testable claim each.
   "Fast" and "intuitive" are not requirements.
4. **What, not how.** spec.md states behavior and contracts. Layout, component
   inventories, colors, field types, and stack hints go in `ui-evidence.md`,
   and spec.md points to it. A requirement may name a screen ("the Board
   screen") as long as that screen is described in ui-evidence.md.
5. **Unknowns are markers, never silence.** Anything that changes scope,
   security or privacy, or user experience gets an inline
   `[NEEDS CLARIFICATION: C-n]` and a row in the Clarifications table with
   options and a recommended default, so `/speckit-clarify` can settle it in
   one sitting. There is no cap on markers. Low-impact gaps get a stated
   default under Assumptions instead (stated, never silent). No "TBD", "etc.",
   or "and so on" anywhere.
6. **Consistent nouns.** One name per entity and screen, used everywhere in
   both files.
7. **Scope honesty.** "What it deliberately leaves out" lists what the video
   did not cover, so the implementer does not gold-plate.

## Where each part of the video lands

| From the video | In spec.md | In ui-evidence.md |
|---|---|---|
| Source, duration, date | `Input`: `Video <file or URL> (<duration>), processed <date>` | Same line at the top |
| Demo type (working app vs. promo) | First line of "The one idea" context, under How to read this | |
| What the product is, who it is for | How to read this | |
| Each demonstrated flow | One user story, prioritized P1 (the core loop) downward, with an Independent Test and Given/When/Then acceptance scenarios citing timestamps | Step-by-step flow with screen transitions and timestamps |
| Each behavior shown or narrated | FR-nnn in EARS | |
| Empty, loading, error states seen or implied | Edge Cases list and table, each mapped to an FR or NFR | States per screen |
| Platform, persistence, auth, narrated performance | NFR-nnn in EARS, numbers with units | |
| Entities implied by the UI | Key Entities (meaning and relationships, no types) | Data model: fields, inferred types, which screen evidences each field |
| Each distinct screen | Named only | Full screen spec (purpose, layout, components, states, navigation) |
| Visible framework or narrated stack | Nothing | Implementation hints, or "stack-agnostic" |
| Outcomes the demo shows | SC-nnn, measurable and technology-agnostic (e.g., "a user moves a card between columns in one drag"). Thresholds the video does not show become a C-n marker | |
| Ambiguities, contradictions, off-screen behavior | `[NEEDS CLARIFICATION: C-n]` plus a Clarifications row, or an Assumption | |

## Promo vs. working app

For a scripted promo, narration-only capability claims (agent counts, speed
superlatives, "automatically" with no visible result) go to Assumptions or a
C-n marker, never into FRs as if demonstrated. For a mixed recording, judge
each claim on whether a frame shows it.

## Quality checklist (verify before delivering)

- [ ] Section order and headings match the resolved template
- [ ] Every user story has an Independent Test and at least one Given/When/Then with a timestamp
- [ ] Every FR and NFR is EARS, has an id, a timestamp citation, and a Source tag
- [ ] Every edge case appears in the table with a requirement id
- [ ] Every `[NEEDS CLARIFICATION: C-n]` has a Clarifications row with a recommended default, and every row has a marker
- [ ] Every SC is measurable and names no technology
- [ ] Every screen visible in the keyframes appears in ui-evidence.md
- [ ] Entity and screen names are identical across both files
- [ ] Nothing in spec.md requires watching the video, or describing layout, to understand
- [ ] `grep -c $'\xe2\x80\x94'` on both files returns 0 (no em dash characters)
