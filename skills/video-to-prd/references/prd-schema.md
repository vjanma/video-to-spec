# PRD schema for video-derived products

## Contents

1. Document quality bar
2. Required sections
3. Requirement writing
4. AI and automation specification
5. Metrics and targets
6. MVP and phases
7. Launch criteria
8. Visual evidence placement

## 1. Document quality bar

Write an implementation-grade PRD, not a feature summary. It must let product, design, engineering, data/AI, security, and business stakeholders understand the product system and make concrete decisions.

The PRD must:

- preserve traceability to the video and evidence notes;
- distinguish demonstrated behavior from inference and recommendation;
- explain object relationships and state transitions;
- contain prioritized, testable functional requirements;
- define AI behavior and human controls when relevant;
- specify non-functional requirements, data entities, metrics, risks, and launch gates;
- embed screenshots as evidence rather than decoration.

## 2. Required sections

### Document metadata

Include status, version, date, product, primary surface, audience, source video, evidence-notes link, and evidence limitations.

### Executive summary

State what the product is, who it serves, the end-to-end workflow, and the main value proposition. Explain whether it is an application, operating system, platform, workflow engine, AI copilot, data product, or combination.

### Product vision

Include a vision statement, strategic thesis, product promise, differentiation, and 4–7 product principles.

### Problem definition

Describe the current workflow, fragmentation, decision problems, consequences, and business opportunity. Do not invent market size.

### Goals and non-goals

List outcome-oriented goals and explicit initial non-goals. Non-goals should prevent scope creep and unsafe interpretation of demonstrated autonomy.

### Target users and jobs to be done

For each meaningful persona, provide role, primary job, pain, need, and success state. Add concise jobs-to-be-done statements.

### End-to-end experience

Describe the lifecycle from initial input through final outcome. Use a Mermaid flow when three or more dependent stages or downstream update paths materially benefit from visualization.

### Information architecture and lifecycle

Define organization/workspace hierarchy, core objects, relationships, versioned artifacts, decisions/audit events, and relevant lifecycle states.

### Functional requirements

Group by stable capability rather than copying screen order. Typical groups include:

- portfolio/home;
- projects/workspaces and sources;
- discovery/ideation;
- visualization/filtering/comparison;
- AI copilot and agent orchestration;
- architecture/validation;
- persistent object or venture creation;
- analytics, market, customer, and risk;
- intelligence assets and exports;
- strategy decisions and propagation;
- roadmap, tasks, and autonomous updates;
- collaboration, matching, or resources;
- packaging, pitch, reporting, or sales materials;
- financial models and scenarios;
- completion, stale-data, and notification state.

### AI orchestration and safety

Specify context, retrieval, run planning, specialist selection, tool use, synthesis, evidence, verification, progress, cancellation, mutation preview, approval policy, atomic application, audit, undo, and failure handling.

### Roles and permissions

Define organization admin, project/object owner, operator, contributor/analyst, reviewer/advisor, and viewer as appropriate. Object-level restrictions override role defaults.

### Non-functional requirements

Define measurable expectations for performance, long jobs, availability, durability, security, privacy, tenant isolation, auditability, accessibility, internationalization, browser/device support, observability, and export fidelity.

### Data model

List minimum canonical entities and relationships. Require derived objects to reference an input snapshot, sources, model/agent/tool versions, generation time, approval state, and version history.

### Instrumentation and success metrics

Define a north-star metric, activation funnel, decision quality, evidence quality, reliability guardrails, time-to-value, execution, packaging, and retention. List the events required to calculate them.

### MVP and delivery phases

Define a first complete loop, a repeatability/collaboration phase, and a platform/network phase. Do not call disconnected mock screens an MVP.

### Risks, dependencies, launch criteria, and open decisions

Cover AI quality, false precision, unsafe state changes, privacy, inconsistency, financial correctness, cost/latency, export drift, sensitive IP, data licensing, and commercialization choices as applicable.

### Visual evidence gallery

End with a compact screenshot index or gallery when the user benefits from seeing the complete captured journey in one place.

## 3. Requirement writing

Use this format:

| ID | Pri. | Requirement | Acceptance criteria |
|---|---:|---|---|
| AREA-01 | P0 | State one user- or system-visible capability. | Describe observable, testable completion conditions. |

Rules:

- Use unique, stable prefixes by capability.
- Use **P0** for the first complete product loop, **P1** for repeatability/collaboration improvements, and **P2** for later platform expansion.
- Write one capability per requirement.
- Make acceptance criteria observable and falsifiable.
- Name required inputs, outputs, permissions, states, and error behavior.
- Avoid “easy,” “intuitive,” “fast,” “robust,” or “secure” without measurable criteria.
- Do not encode unverified architecture choices as product requirements.
- Link production-critical inference to a stated reason.

## 4. AI and automation specification

For agentic products, define this lifecycle:

1. Scope organization/object, user permissions, mode, and policy.
2. Retrieve authorized structured state and sources from a pinned snapshot.
3. Plan specialist roles, tools, limits, and output schema.
4. Execute bounded work with progress, timeout, retry, and cancel.
5. Synthesize conflicts into a structured result.
6. Verify evidence, consistency, numerics, and policy.
7. Propose state changes as an inspectable diff.
8. Apply approved changes atomically, audit them, and support undo.

Require citations or assumption labels for material claims. Do not require hidden chain-of-thought; require inspectable evidence, actions, and concise rationale.

Default consequential mutations to preview-and-apply. Allow policy-controlled auto-application only for clearly bounded low-risk actions. Never infer authorization for external communication, purchases, legal filings, or financial transactions from a demo.

## 5. Metrics and targets

Prefer product-loop metrics over content-volume metrics. Good examples:

- time from usable context to approved execution-ready output;
- percentage of activated users completing the core lifecycle;
- recommendation acceptance with minor edits;
- percentage of material claims with source or assumption;
- audited high-severity unsupported-claim rate;
- percentage of approved strategies producing completed work;
- percentage of objects reaching approved packaging;
- active operator time and retention.

Label numeric targets as recommended unless the user or source provides a baseline.

## 6. MVP and phases

The MVP must deliver the source video's main promise end to end. Include minimum trust, approval, audit, and export behavior needed for real use.

Use later phases for collaboration depth, connectors, template/rubric reuse, portfolio optimization, marketplaces, or external networks. Do not postpone safety and tenant isolation as “enterprise features.”

## 7. Launch criteria

Define concrete gates such as:

- a new user completes the core loop without staff editing internal state;
- material claims are cited or labeled assumptions;
- approved metrics remain consistent across outputs;
- AI mutations are previewable, auditable, and reversible;
- exports pass structural and visual QA;
- access boundaries pass security testing;
- p95 latency and background-job reliability meet alpha targets;
- accountable product, domain, and security owners approve release.

## 8. Visual evidence placement

Place the strongest screenshot before or after the requirements it supports. Write alt text that names the product state and evidentiary purpose. Do not use screenshots as substitutes for requirements.

Use relative paths inside the PRD so the deliverable directory remains portable. Render several representative screenshots with absolute paths in the final response when working in the desktop app.
