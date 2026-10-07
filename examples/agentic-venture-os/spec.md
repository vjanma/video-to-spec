# Feature Specification: Agentic Venture Operating System

**Feature Branch**: `001-agentic-venture-os`

**Created**: 2026-10-07

**Status**: Draft

**Input**: Video https://www.youtube.com/watch?v=nGH5mxbcDm4 (03:15), processed 2026-10-07. Timestamps like (video MM:SS) reference that recording. Screen-by-screen detail is in [ui-evidence.md](ui-evidence.md).

## How to read this *(answer first)*

**The one idea**: A founder can take a venture from a research project to an investor-ready package inside one workspace by directing a single conversational co-pilot ("Osa") that reads the project's data and produces concepts, ventures, documents, tasks, and pitch materials on request.

**What this spec covers**: The portfolio dashboard, the project workspace, ideations and their concepts, promoting a concept to a venture, the venture's generated intelligence documents, the venture to-do list and roadmap, and investor packaging (pitch deck and financial model), all steered through Osa. Demo type: **mixed**. A real cursor drives a real web UI with chat, modals, and live list updates, but the voiceover is promotional (video 00:54 "a fleet of over 100 specialized agents", 01:06 "instantly", 02:57 "design-perfect"). Only behavior a frame shows is a requirement; narration-only claims are in Assumptions or Clarifications.

**What it deliberately leaves out**: Team Matching beyond its entry point and empty state (never run on screen, see C-6); the "concept cloud" visualization (narrated at 00:37 to 00:50, never shown, see C-5); editing the generated pitch deck (it opens in what appears to be a separate presentation tool, see C-2); account creation, billing, and settings (not shown); mobile layouts (desktop only in every frame).

**The spec-driven caveat**: This document specifies behavior and contracts, not implementation. It is meant to be regenerated when requirements change, not patched by hand.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Explore a project with Osa and launch an ideation (Priority: P1)

A founder opens a project, asks Osa where to take it next, picks one of the proposed directions, asks for a diagram of the system, and launches an ideation framed by Osa's constraints.

**Why this priority**: This is the loop the demo exists to show (video 00:51 to 01:30): conversation turns into structured work. Without it the rest of the product is a static dashboard.

**Independent Test**: With one project holding a description and existing data, send three chat messages (ask for directions, ask for a diagram, confirm launch) and verify a new ideation appears in the project's Ideations list.

**Acceptance Scenarios**:

1. **Given** the founder is on a project page with the Osa panel showing "Connected" and "Memory ready", **When** they ask "what new directions can we explore to align with the project's goals?", **Then** Osa replies in the panel with numbered directions, each with an opportunity, a proposed venture, and a reason it is promising, and ends with a question asking which to pursue (video 01:12).
2. **Given** Osa has framed a direction with a mission and key constraints, **When** the founder asks to "present the most important elements in a diagram", **Then** Osa returns an inline diagram thumbnail that opens in a diagram viewer with zoom, fit, reset, export to SVG, and close controls (video 01:18, 01:25).
3. **Given** Osa has asked whether to proceed, **When** the founder replies "yes, let's move forward with the new ideation", **Then** Osa confirms the ideation was launched and an ideation form titled from the framed direction is shown with its constraints prefilled (video 01:30).

---

### User Story 2 - Review concepts and promote one to a venture (Priority: P2)

A founder reviews the concepts an ideation generated, rates or comments on them, exports them, and promotes the best one into a venture.

**Why this priority**: Concepts are the raw output of ideation; promotion is how one becomes a venture (video 00:32, narration 00:26 to 00:31 "has already spawned live concepts").

**Independent Test**: With one completed ideation of at least two concepts, open the Completed tab, add a star rating and feedback to one concept, export CSV, and choose "Create Venture & Launch Intelligence" on it; verify a venture appears in the project's Ventures list.

**Acceptance Scenarios**:

1. **Given** a project with completed ideations, **When** the founder selects the Completed tab in Ideations, **Then** concepts are listed grouped by ideation, each group showing its concept count and average score, and the list header shows the total concept count, a selection count, and an Export CSV action (video 00:32).
2. **Given** a concept card, **When** the founder sets a star rating or types in "Add feedback...", **Then** the rating and feedback are saved against that concept (video 00:32).
3. **Given** a concept card, **When** the founder chooses "Create Venture & Launch Intelligence", **Then** a venture is created from the concept, linked to the project, and its Intelligence stage starts (video 00:32, 01:49).

---

### User Story 3 - Review a venture's generated intelligence (Priority: P3)

A founder opens a venture, asks Osa for a summary, and reviews or downloads the documents the intelligence analysis produced.

**Why this priority**: The documents (business plan and ten appendices) are the venture's first tangible output and feed packaging (video 01:49, 01:56).

**Independent Test**: With one venture whose Intelligence stage is Completed, open it, view one document, download one document, and use Download All.

**Acceptance Scenarios**:

1. **Given** a venture whose Intelligence stage is Completed, **When** the founder opens it, **Then** the Intelligence Analysis section shows "Analysis Complete" and lists eleven generated documents, each with view and download actions, plus Download All and View Full Analysis (video 01:49).
2. **Given** the generated documents list, **When** the founder downloads the Business Plan, **Then** they receive an editable word-processor document with a table of contents and sections including Financial Plan with charts (video 01:56, 02:01).
3. **Given** the venture page, **When** the founder asks Osa "what is the venture about in a nutshell?", **Then** Osa answers with a summary, the value proposition, and key stats drawn from the venture's data (video 01:42, 01:49).

---

### User Story 4 - Turn strategy into today's tasks (Priority: P4)

A founder asks Osa for the top target segment, agrees, and asks Osa to update the to-do list with the most important tasks for that focus.

**Why this priority**: It closes the loop from analysis to execution (video 02:06 to 02:35), but a venture is usable without it.

**Independent Test**: On a venture with an existing to-do list, ask Osa to add the five most important tasks for a named focus; verify five new tasks with priorities appear in Venture To Do without reloading and the completion percentage recalculates.

**Acceptance Scenarios**:

1. **Given** the venture page, **When** the founder asks Osa to identify top clients, **Then** Osa ranks customer segments and recommends next steps (video 02:13).
2. **Given** the founder asks "update my todo with the 5 most important tasks related to this for today", **When** Osa completes, **Then** five tasks are added to Venture To Do with priority labels, a "Todo updated" badge appears on the list, and Osa's reply lists the tasks it added (video 02:27).
3. **Given** tasks in Venture To Do, **When** the founder checks one off, **Then** it is shown struck through and the completion percentage updates (video 02:27: 2 of 15 done shows 13%).

---

### User Story 5 - Package the venture for investors (Priority: P5)

A founder asks Osa for the best investor angle, then launches packaging, which produces a pitch deck and a financial model built on that narrative.

**Why this priority**: It is the end of the journey (video 02:38 to 03:05) and depends on Stories 3 and 4.

**Independent Test**: On a venture with a completed Business Plan, open Generate Investor Materials, keep the prefilled requirements, launch, and verify a pitch deck and a financial model with three scenarios are produced.

**Acceptance Scenarios**:

1. **Given** the founder agrees to launch packaging in chat, **When** the Generate Investor Materials dialog opens, **Then** it lists the venture's documents with the Business Plan selected, shows packaging requirements prefilled from the conversation, and offers optional file uploads, Cancel, and Launch Packaging (video 02:44).
2. **Given** packaging has run, **When** the founder opens the pitch deck, **Then** it contains slides built on the agreed narrative, including the problem, outcomes, competitive differentiation, team, and roadmap (video 02:47, 03:00).
3. **Given** packaging has run, **When** the founder opens the financial model, **Then** it shows customer projections, cohort retention, and unit economics, each switchable between Base Case, Conservative, and Upside scenarios (video 03:03).

---

### User Story 6 - See the portfolio at a glance (Priority: P6)

A founder lands on a dashboard showing portfolio totals and all projects, and opens one.

**Why this priority**: It is the entry point (video 00:00 to 00:10) but delivers little value alone.

**Independent Test**: With several projects, load the dashboard and verify the four totals match the data and each project card opens its project.

**Acceptance Scenarios**:

1. **Given** a signed-in founder, **When** they open the dashboard, **Then** they see totals for Projects, Ideations, Generated Concepts, and Ventures, each with a trend percentage and a sparkline (video 00:00).
2. **Given** the dashboard, **When** the founder switches between Active and Archived, **Then** the project grid shows only projects in that state with the count in the tab label (video 00:00).
3. **Given** a project card, **When** the founder chooses "Open Project", **Then** the project page opens (video 00:10, 00:17).

---

### Edge Cases

- What happens when a project has no ideations or ventures yet?
- What happens when a venture stage has not started?
- What happens when Team Matching has never run?
- What happens when no materials have been generated?
- What happens while Osa is still building memory?
- What happens when packaging is launched with no documents selected?
- What happens when Osa cannot complete a request?
- What happens when a document download fails?

| Situation | Required behavior | Requirement |
|-----------|-------------------|-------------|
| Project card with no ideas or ventures (video 00:00, "0 ideas", "0 ventures", "0%") | Card shows zero counts and 0% progress, still openable | FR-002 |
| Archived tab with no projects (video 00:00, "Archived (0)") | Empty grid with the zero count in the tab | FR-002 |
| Venture stage not started (video 01:49, "Not Started") | Stage tile shows "Not Started" | FR-012 |
| Team Matching never run (video 01:49) | Shows "No matching analysis yet" with a Find Matches action | FR-013 |
| No pitch materials yet (video 01:42, "No materials generated yet") | Pitch & Materials shows the empty message and a Generate action | FR-020 |
| Osa building memory (video 03:03, "Building memory...") | Status shows "Building memory..." instead of "Memory ready"; chat remains usable [NEEDS CLARIFICATION: C-7] | FR-005, NFR-002 |
| Packaging with zero documents selected (Inferred) | Launch Packaging is disabled until at least one document is selected | FR-020 |
| Osa request fails (Inferred, not shown) | Osa replies with a named error and the request can be retried; no partial changes to tasks or ventures | NFR-003 |
| Document download fails (Inferred, not shown) | Named error with a retry; other documents unaffected | NFR-003 |

## Requirements *(mandatory)*

### Functional Requirements

**Portfolio and projects**

- **FR-001**: The system shall show, on the dashboard, totals for Projects (with active and archived counts), Ideations, Generated Concepts, and Ventures, each with a trend percentage and a sparkline. (video 00:00) Source: Observed
- **FR-002**: The system shall list projects as cards showing name, creation date, description, idea count, venture count, a progress percentage, and an Open Project action, filtered by an Active or Archived tab whose label shows its count. (video 00:00) Source: Observed
- **FR-003**: WHEN the founder chooses New Project, the system shall create a project with a name and description. (video 00:00) Source: Inferred (button shown, flow not demonstrated)
- **FR-004**: The system shall show, on a project page, the project's name, description, creation date, status, and counts of Ideations, Concepts, Refined Concepts, and Ventures. (video 00:17) Source: Observed
- **FR-005**: The system shall show an Osa panel on every project and venture page with connection status, memory status, session history, an expand control, the current context (project or venture name), context-specific quick actions, and a text input with a microphone control. (video 00:17, 01:49) Source: Observed
- **FR-006**: The system shall show Project Analytics cards (portfolio health, market potential, innovation focus, execution readiness, strategic directive, key findings, sectors explored) with a Regenerate action that recomputes them from the project's refined concepts. (video 00:17, 00:50) Source: Observed (cards), Inferred (recompute behavior)

**Osa and ideation**

- **FR-007**: WHEN the founder sends a message to Osa, the system shall reply in the panel with formatted text grounded in the current project or venture's data, ending with a suggested next step. (video 01:12, 01:25) Source: Observed
- **FR-008**: WHEN the founder asks Osa for a diagram, the system shall render a node-and-edge diagram inline and open it in a diagram viewer with zoom in, zoom out, fit, reset, export to SVG, and close. (video 01:18, 01:25) Source: Observed
- **FR-009**: WHEN the founder confirms an ideation in chat, the system shall create an ideation whose title, guidance, and exploration constraints (market focus, technology scope, regulatory) are prefilled from Osa's framing, and accept supporting materials before launch. (video 01:30) Source: Observed (form partly visible behind the chat; field set approximate)
- **FR-010**: The system shall list a project's ideations with title, date, and status, filterable by All and Completed. (video 00:17, 00:32) Source: Observed
- **FR-011**: WHILE the Completed tab is selected, the system shall list concepts grouped by ideation, each group showing concept count and average score, each concept showing title, maturity badge, sector tag, description, two scores, a star rating, a feedback field, Details, Open, and Create Venture & Launch Intelligence, with multi-select and Export CSV. (video 00:32) Source: Observed. The meaning of the two scores is [NEEDS CLARIFICATION: C-4]; filtering concepts by score, and the narrated concept cloud, is [NEEDS CLARIFICATION: C-5]

**Ventures**

- **FR-012**: The system shall show each venture's four stages (Ideation, Intelligence, Matching, Packaging), each with a status of Not Started, In Progress, or Completed. (video 01:49) Source: Observed (Not Started, Completed), Inferred (In Progress)
- **FR-013**: The system shall show Team Matching with a Find Matches action and an empty state when no matching has run. (video 01:49) Source: Observed. Matching behavior is [NEEDS CLARIFICATION: C-6]
- **FR-014**: WHEN a venture's Intelligence stage completes, the system shall list eleven generated documents (Vertical Report, Policy Appendix, Macroeconomic Appendix, IP Intelligence Appendix, Business Intelligence Appendix, Market Analysis Appendix, Client Identification Appendix, Investment Trends Appendix, Startup Landscape Appendix, Problem Solution Appendix, Business Plan), each viewable and downloadable, with Download All. (video 01:49) Source: Observed
- **FR-015**: The system shall deliver downloaded documents as editable word-processor files. (video 01:56) Source: Observed (opened in a desktop word processor); format [NEEDS CLARIFICATION: C-3]
- **FR-016**: The system shall show venture Analytics: market opportunity (TAM, SAM, SOM), competitive landscape (positioning scatter with named competitors), risk assessment (scored risks), and customer segments (scored segments). (video 01:42) Source: Observed
- **FR-017**: The system shall show a Venture Roadmap of milestones on a week timeline (week 0 to week 16 in the demo), each with title, description, category, checklist items, duration, and status (Completed, In Progress, Pending, Key Decision), with a draggable current-week marker and Add Milestone. (video 01:42, 02:27) Source: Observed

**Execution**

- **FR-018**: The system shall show Venture To Do with tasks that each have a title, a priority (High, Medium, Low), a done state, and a drag handle, plus a completion percentage and Add Task. (video 02:27) Source: Observed
- **FR-019**: WHEN the founder asks Osa to update the to-do list, the system shall add the tasks Osa proposes to Venture To Do, show a "Todo updated" badge, and list the added tasks in Osa's reply. (video 02:27) Source: Observed. Whether Osa may change tasks without an explicit request is [NEEDS CLARIFICATION: C-1]

**Packaging**

- **FR-020**: WHEN the founder launches packaging, the system shall show Generate Investor Materials with the venture's documents (Business Plan selected by default), a requirements text prefilled from the conversation, requirement chips (pitch, audience, material priorities), optional file uploads, Cancel, and Launch Packaging. (video 02:44, 02:53) Source: Observed
- **FR-021**: WHEN packaging completes, the system shall produce a pitch deck built on the chosen narrative with the slide count stated in the pitch requirement (11 to 13 in the demo). (video 02:44, 02:47, 03:00) Source: Observed (deck seen), Inferred (slide count honored). Where the deck opens is [NEEDS CLARIFICATION: C-2]
- **FR-022**: WHEN packaging completes, the system shall produce a financial model showing customer projections (month 1, 12, 24), cohort retention by month, and unit economics (CAC, LTV, LTV:CAC, payback period, gross margin, revenue retention, each with a rating badge), switchable between All Scenarios, Base Case, Conservative, and Upside. (video 03:03) Source: Observed. Values are model outputs; how assumptions are set is [NEEDS CLARIFICATION: C-8]

### Key Entities *(include if feature involves data)*

- **Project**: A long-lived research container with a description and status; owns ideations, concepts, ventures, and analytics.
- **Ideation**: A framed exploration inside a project (title, guidance, constraints, materials); produces concepts.
- **Concept**: A candidate venture idea produced by an ideation, with maturity, sector, scores, and founder ratings and feedback.
- **Venture**: A concept promoted to an active initiative; belongs to one project and moves through four stages.
- **Generated Document**: An intelligence output of a venture (business plan or appendix), viewable and downloadable.
- **Milestone**: A roadmap item of a venture with duration, category, checklist, and status.
- **Task**: A to-do item of a venture with priority and done state; may be created by the founder or by Osa.
- **Osa Session**: A conversation with Osa scoped to a project or venture, with persistent memory.
- **Investor Package**: The outputs of packaging for a venture: a pitch deck and a financial model with scenarios.

### Non-functional Requirements

- **NFR-001**: The system shall run as a desktop web application at a viewport width of 1280 px or more. (video 00:00 to 03:14, every frame) Source: Observed (desktop only); mobile is out of scope.
- **NFR-002**: The system shall persist Osa's memory per project and per venture across sessions, showing "Memory ready" when loaded and "Building memory..." while updating. (video 00:17, 03:03) Source: Inferred from status labels
- **NFR-003**: IF an Osa request or a generation step fails, THEN the system shall show a named error with a retry and apply no partial changes to tasks, ventures, or documents. Source: Inferred (no failure shown)
- **NFR-004**: The system shall attribute every task, venture, and document Osa creates to Osa, distinguishable from founder-created items. Source: Inferred (supports C-1)
- **NFR-005**: WHEN Osa updates a list on the page, the system shall show the change without a page reload. (video 02:27) Source: Observed. Response-time target is [NEEDS CLARIFICATION: C-9]

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A founder goes from a first question to a launched ideation in 3 or fewer chat messages (the demo uses 3, video 01:00 to 01:30).
- **SC-002**: A founder promotes a concept to a venture in 1 action from the concept list.
- **SC-003**: 100% of the 11 generated documents are viewable and downloadable once Intelligence completes, individually and through Download All.
- **SC-004**: After a to-do request, every task Osa added is visible in Venture To Do with a priority, and the completion percentage matches done tasks divided by total tasks.
- **SC-005**: One packaging run yields a pitch deck within the requested slide range and a financial model with all 3 named scenarios populated.
- **SC-006**: Dashboard totals equal the counts of underlying records for all 4 metrics.

## Assumptions

- A single founder account owns all projects; collaboration and roles are out of scope for v1. (video 00:00 "Welcome back, Founder")
- The "fleet of over 100 specialized agents" (video 00:54) is an implementation choice, not a requirement; this spec states outcomes only.
- "Instantly" and "surgically precise" (video 01:06, 02:23) are marketing language and set no performance requirement beyond C-9.
- Project Analytics and venture Analytics values are generated from the project's or venture's data and refresh on Regenerate or when the underlying data changes.
- Concept maturity values beyond "solidified" and "Refined" exist but were not shown; they are an ordered set defined during planning.
- The header product name reads "airos.operatingsystem" (video 00:00, small text, approximate); the product is called Agentic Venture Operating System in this spec.

## Clarifications

| Id | Decision | Options | Recommended default | Lands in |
|----|----------|---------|---------------------|----------|
| C-1 | May Osa change tasks, ventures, or documents without an explicit request? Narration says the OS "autonomously updates" (video 02:26), but the frame shows it acting on a direct request. | Only on explicit request · Propose then confirm · Fully autonomous | Only on explicit request, with Osa-created items attributed (NFR-004) and undoable; this is what the frames show | FR-019, NFR-004 |
| C-2 | Where does the generated pitch deck open? The deck at 02:47 is in an editor with Theme, Share, Agent, and Present controls that looks like a separate presentation service. | In-app deck viewer · Export to a .pptx file · Hand off to an external presentation service | Export to .pptx plus an in-app read-only preview; an external integration is a later feature | FR-021 |
| C-3 | Document format and viewing: documents opened in a desktop word processor (video 01:56). | .docx download only · In-app viewer plus .docx · PDF | In-app viewer (the eye action) plus .docx download | FR-014, FR-015 |
| C-4 | What do the two numbers on each concept card mean (video 00:32, both "4")? Narration mentions filtering by "technical feasibility and market viability" (00:42). | Feasibility and viability scores · Rating and trend · Other | Technical feasibility and market viability, each 1 to 5, used for filtering | FR-011 |
| C-5 | Is the "concept cloud" visualization (narrated 00:37 to 00:50, never shown) in scope? | Build the visualization · Filterable list only · Defer | Filterable list with feasibility and viability filters in v1; defer the visualization | FR-011 |
| C-6 | What does Team Matching do? Osa later cites "our Matching Analysis" and investor archetypes (video 02:38) while the stage showed Not Started (01:49). | Co-founder matching · Investor matching · Both | Both, as named in the panel subtitle "Co-founders & investor matching"; behavior specified in a separate feature | FR-013 |
| C-7 | Can the founder chat while Osa shows "Building memory..."? | Chat allowed, memory catches up · Chat blocked until ready | Chat allowed; replies may not yet reflect the newest data, and the status says so | NFR-002 |
| C-8 | Where do the financial model's assumptions come from, and can the founder edit them? | Generated, read-only · Generated, editable assumptions · Founder-entered | Generated from the business plan, with editable assumptions per scenario | FR-022 |
| C-9 | What response time is acceptable for Osa replies and generation steps? The demo cuts past waits. | Chat reply time with a unit, generation with a progress state | First chat token within 3 s at p95; long generations (intelligence, packaging) show progress and may take minutes | NFR-005 |
