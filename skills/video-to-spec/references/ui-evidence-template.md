<!--
  HOUSE RULE: Never use em dashes. Use a comma, a colon, a period, or parentheses instead.
  Sibling to spec.md. Holds the visual evidence a spec has no room for: how the
  product looks and what was seen, as input to /speckit-plan. spec.md says what
  the product does; this file says what the recording showed.
-->
# UI Evidence: [PRODUCT OR FEATURE NAME]

**Source**: Video [file or URL] ([duration]), processed [DATE]

**Spec**: [spec.md](spec.md)

**Demo type**: [Working-app recording | Scripted promo | Mixed], [one-line reason]

Timestamps like (video MM:SS) reference the source recording. Every item is
Observed (seen in a frame or narrated) unless marked Inferred.

## Screens

<!-- One subsection per distinct screen or view seen. Names must match spec.md. -->

### S1. [Screen name] (video MM:SS)

- **Purpose**: [why this screen exists]
- **Layout**: [regions top to bottom, left to right (header, sidebar, main), and what each contains]
- **Components**: [each interactive element: label, type, what happens on interaction]
- **States**: [empty, loading, error, populated, as observed or Inferred]
- **Navigation**: [how the user arrives, where they can go]
- **Visual notes**: [colors, typography, iconography only when distinctive and visible]
- **Related**: [FR-nnn, User Story n]

## Flows

<!-- One per user story, as a step sequence with screen transitions. -->

### F1. [Flow name] (User Story 1)

1. (video MM:SS) On [S1], user [action] → [result]
2. (video MM:SS) [S2] opens, showing [what]

## Data model (Inferred)

<!-- Fields and types the UI implies. Every entity here appears in spec.md Key Entities. -->

### [Entity]

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| [name] | [string, number, enum (values), date, reference to X] | [S1 (video MM:SS): label shown on card] |

## Implementation hints

[Only what the video reveals: visible framework artifacts, narrated stack. Otherwise: "Stack-agnostic: the recording reveals no implementation details."]

## Coverage notes

- **Frames reviewed**: [n of N, sampling method if more than 30]
- **Sparse or blurry stretches**: [MM:SS to MM:SS, reconstructed from narration]
- **Low-confidence reads**: [values read from small text, marked approximate]
