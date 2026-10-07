<!--
  HOUSE RULE: Never use em dashes. Use a comma, a colon, a period, or parentheses instead.
  This template is Spec Kit's spec-template.md with house additions. Preset: ~/Cowork/sdd-preset.
  BUNDLED COPY for video-to-spec. Used only when the target repository has no .specify/;
  otherwise the repository's own resolved spec-template wins. Re-sync from the preset when it
  changes (standards flow downward only): cp ~/Cowork/sdd-preset/templates/spec-template.md here,
  then restore this note.
-->
# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`

**Created**: [DATE]

**Status**: Draft

**Input**: User description: "$ARGUMENTS"

## How to read this *(answer first)*

<!--
  Write this block last, read it first. Four short entries, no more than a paragraph each.
-->

**The one idea**: [One sentence. The single claim this feature rests on, stated so a reader could disagree with it.]

**What this spec covers**: [The scope in one or two sentences: which stories, which surfaces, which release.]

**What it deliberately leaves out**: [Named exclusions, so nobody assumes them back in. If something is deferred, name the feature or version it moves to.]

**The spec-driven caveat**: This document specifies behavior and contracts, not implementation. It is meant to be regenerated when requirements change, not patched by hand. Full spec-driven development is a poor fit for small, exploratory, or throwaway changes; if this feature is one of those, say so here and use iterative prompting instead.

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.

  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

Every edge case above MUST also appear as a row below, with the requirement that governs it. An edge case with no requirement id is an unrecorded decision.

| Situation | Required behavior | Requirement |
|-----------|-------------------|-------------|
| [e.g., input exceeds the stated size limit] | [e.g., reject with E_TOO_LARGE and the limit in the message] | [FR-nnn or NFR-nnn] |
| [e.g., two callers act on the same record at once] | [e.g., second caller receives E_CONFLICT; first write wins] | [FR-nnn] |

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

<!--
  HOUSE RULE: every functional requirement MUST be written in EARS form
  (Easy Approach to Requirements Syntax). Pick one of the five patterns below;
  each one collapses to a single testable claim. "Should work well" is not a requirement.
-->

**EARS patterns** (use exactly one per requirement):

| Pattern | Shape | Example |
|---------|-------|---------|
| Ubiquitous | The system shall ... | The system shall treat a record as immutable once written. |
| Event-driven | WHEN [trigger], the system shall ... | WHEN a request is registered, the system shall respond with an acknowledgement containing its id. |
| State-driven | WHILE [state], the system shall ... | WHILE an export is running, the system shall reject a second export for the same dataset. |
| Unwanted behavior | IF [condition], THEN the system shall ... | IF a verifier identity equals the producer identity, THEN the system shall reject the receipt with E_SELF_VERIFY. |
| Optional feature | WHERE [feature is present], the system shall ... | WHERE a second-opinion check is configured, the system shall require a different model family. |


- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*Example of marking unclear requirements:*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

*House form for markers: number them and collect them in the Clarifications table at the end.*

- **FR-008**: WHEN a user signs in, the system shall authenticate via [NEEDS CLARIFICATION: C-1]

### Key Entities *(include if feature involves data)*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

### Non-functional Requirements

<!--
  Same EARS discipline, NFR- ids. Every number needs a unit and, for latency or throughput,
  the reference hardware named in plan.md. Cover: performance, output size or token budget,
  reliability, security, privacy, portability, observability, as they apply.
-->

- **NFR-001**: The system shall [performance bound with a unit, e.g., "respond to a read within 200 ms at p95 on the reference hardware"]
- **NFR-002**: The system shall [size bound, e.g., "keep default output under 2,000 tokens"]
- **NFR-003**: IF [failure condition], THEN the system shall [degradation behavior, e.g., "fail closed with a named error"]
- **NFR-004**: The system shall [security or privacy property, e.g., "store no secret in any log line"]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: [Measurable metric, e.g., "Users can complete account creation in under 2 minutes"]
- **SC-002**: [Measurable metric, e.g., "System handles 1000 concurrent users without degradation"]
- **SC-003**: [User satisfaction metric, e.g., "90% of users successfully complete primary task on first attempt"]
- **SC-004**: [Business metric, e.g., "Reduce support tickets related to [X] by 50%"]

## Assumptions

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right assumptions based on reasonable defaults
  chosen when the feature description did not specify certain details.
-->

- [Assumption about target users, e.g., "Users have stable internet connectivity"]
- [Assumption about scope boundaries, e.g., "Mobile support is out of scope for v1"]
- [Assumption about data/environment, e.g., "Existing authentication system will be reused"]
- [Dependency on existing system/service, e.g., "Requires access to the existing user profile API"]

## Clarifications

<!--
  Every [NEEDS CLARIFICATION: C-n] marker in this document gets one row. State the options
  considered and a recommended default so the decision can be made in one sitting.
  The spec is not complete while any row is undecided. When decided, record the decision
  in the Decision column, mark the in-text location DECIDED, and keep the row.
-->

| Id | Decision | Options | Recommended default | Lands in |
|----|----------|---------|---------------------|----------|
| C-1 | [What must be decided, as a question] | [Option A · Option B · Option C] | [Which one, and the one-line reason] | [FR-nnn, section, or task] |
| C-2 | | | | |
