# PRD Template & Writing Rules

The PRD you produce will be handed directly to an AI coding tool (Claude Code,
Cursor, etc.) to implement the product. It must be **self-contained**: the
implementer will never watch the video. Everything they need must be in the
document, in unambiguous prose.

## Writing rules

1. **Ground every claim in the video.** Each functional requirement cites the
   timestamp(s) where it was demonstrated or narrated, e.g. `(video 02:14)`.
   Never invent features that weren't shown or described.
2. **Distinguish observed vs. inferred.** UI you saw in screenshots and
   behavior the narrator described are *observed*. Data models, validation
   rules, and behavior you deduced are *inferred* — mark them and justify
   briefly. Unresolvable gaps go in Open Questions, not into requirements.
3. **No placeholders.** No "TBD", "etc.", or "and so on" inside requirements.
   If something is unknown, it is an Open Question with a recommended default.
4. **Testable acceptance criteria.** Every FR has Given/When/Then criteria a
   machine could check. "Fast" and "intuitive" are not criteria; "list renders
   within one screen without pagination for up to 50 items" is.
5. **Describe UI in text precisely enough to rebuild it.** Region-by-region:
   layout structure, components, labels, states (empty/loading/error/filled),
   and what each interaction does. Name colors/typography only when they are
   distinctive and visible in the screenshots.
6. **Use consistent nouns.** Pick one name per entity/screen on first mention
   and use it everywhere (e.g. always "Task", never alternating with "todo"/"item").
7. **Keep scope honest.** Non-goals list what the video did NOT cover so the
   implementer doesn't gold-plate.

## Document structure

```markdown
# PRD: <Product Name>

> Generated from <source: filename or URL> (<duration>) on <date>.
> Timestamps like (video MM:SS) reference the source recording.

## 1. Overview
2–4 paragraphs: what the product is, the problem it solves, who it's for,
and the core value demonstrated in the video.

## 2. Goals & Non-Goals
**Goals** — bullet list of outcomes this implementation must achieve.
**Non-Goals** — explicitly out of scope (not shown/mentioned in the video).

## 3. Users & Roles
Table: Role | Description | Key capabilities. If the video shows a single
user type, say so.

## 4. Functional Requirements
Grouped by feature area. Each requirement:

### FR-<n>: <Short imperative title>
- **Description:** what the system does, in 1–3 sentences. (video MM:SS)
- **Behavior:** precise interaction flow — what the user does, what the UI
  shows, what changes persist.
- **Acceptance criteria:**
  - Given …, when …, then …
  - (2–5 criteria per FR)
- **Source:** Observed | Inferred (with rationale)

## 5. Screen-by-Screen UI Specification
One subsection per distinct screen/view seen in the video:

### 5.<n> <Screen name> (video MM:SS)
- **Purpose:** why this screen exists.
- **Layout:** regions top-to-bottom / left-to-right (header, sidebar, main…)
  and what each contains.
- **Components:** each interactive element — label, type, and what happens
  on interaction.
- **States:** empty, loading, error, populated — as observed or inferred.
- **Navigation:** how the user arrives here and where they can go.

## 6. User Flows
Numbered end-to-end flows demonstrated in the video, as step sequences:
"1. User clicks X on Screen A → 2. Modal Y opens → …" with timestamps.

## 7. Data Model (Inferred)
Entities with fields, types, and relationships, derived from what the UI
displays and the narration. Mark every entity Inferred; note which screen(s)
evidence each field.

## 8. Non-Functional Requirements
Only what is evidenced or clearly implied: platform (web/desktop/mobile),
responsiveness seen, persistence expectations, auth if shown, performance
characteristics the narrator called out.

## 9. Suggested Implementation Notes
Brief, optional: tech-stack hints ONLY if the video reveals them (visible
framework artifacts, narrator statements). Otherwise state the PRD is
stack-agnostic.

## 10. Open Questions & Assumptions
Table: # | Question/Gap | Why it matters | Recommended default.
Everything ambiguous lands here — with a sensible default so an AI
implementer is never blocked.
```

## Quality bar checklist (verify before delivering)

- [ ] Every FR has a timestamp citation and testable acceptance criteria
- [ ] Every screen visible in the keyframes appears in section 5
- [ ] No requirement contradicts another; entity names are consistent throughout
- [ ] Nothing in sections 1–8 requires watching the video to understand
- [ ] Open Questions all have recommended defaults
