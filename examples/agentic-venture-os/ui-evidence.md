<!--
  HOUSE RULE: Never use em dashes. Use a comma, a colon, a period, or parentheses instead.
  Sibling to spec.md. Holds the visual evidence a spec has no room for.
-->
# UI Evidence: Agentic Venture Operating System

**Source**: Video https://www.youtube.com/watch?v=nGH5mxbcDm4 (03:15), processed 2026-10-07

**Spec**: [spec.md](spec.md)

**Demo type**: Mixed. A real cursor, typed chat input, modals, and live list updates show a working web app; the voiceover is a scripted promo.

Timestamps like (video MM:SS) reference the source recording. Every item is Observed (seen in a frame or narrated) unless marked Inferred.

## Screens

### S1. Dashboard (video 00:00, 00:10)

- **Purpose**: Portfolio overview and entry to projects.
- **Layout**: Top bar (product name at left, approximate "airos.operatingsystem"; Home link at right). Hero band with the "O" mark with superscript n, "OS", "AGENTIC VENTURE OPERATING SYSTEM", tagline "From insight to action, at the n-th speed", and glass torus imagery. Greeting "Welcome back, Founder" with sparkle icon and subtitle "Your venture ecosystem at a glance". Row of four stat cards. "Your Projects" section header with subtitle "Organize and track your venture initiatives" and a New Project button at right. Active and Archived tabs. Three-column project card grid.
- **Components**: Stat cards: icon, trend chip (for example "+12%"), label, large number, caption ("18 active, 0 archived", "Across all projects", "From completed ideations"), area or line sparkline. Project card: drag handle, accent bar, name, date, two-line description, chips for ideas, ventures, progress percent, Open Project button with arrow; overflow menu on one card.
- **States**: Populated (18 active). Archived tab shows "(0)". Cards with "0 ideas", "0 ventures", "0%".
- **Navigation**: Open Project goes to S2.
- **Visual notes**: Pale mint background, dark green primary buttons, rounded cards with soft shadows, light serif-free type.
- **Related**: FR-001, FR-002, FR-003, User Story 6

### S2. Project page (video 00:17, 00:27, 00:50)

- **Purpose**: Workspace for one project.
- **Layout**: Breadcrumb (Dashboard > Projects > BaseLayer). Header card: name, description, created date, Active badge, overflow menu, decorative ring. Left column: four count tiles (Ideations 2, Concepts 221, Refined Concepts 23, Venture 1), Ideations panel, Ventures panel, Project Analytics. Right column: Osa panel (S4 docked).
- **Components**: Ideations panel: title, subtitle "Generate and refine venture concepts", New Ideation button, All (2) and Completed (2) tabs, rows with ideation title, "Refined" badge, date. Ventures panel: subtitle "Active venture initiatives", New Venture button, venture card (name, "New" badge, description, "Intelligence" chip). Project Analytics: subtitle "Agentic insights for the Refined Concepts", Regenerate button, cards: Portfolio Health ("23 Refined Concepts", "48% of concepts are solidified and ready for immediate seed-stage development"), Market Potential ("$33.3B Total TAM"), Innovation Focus ("Precision Agritech"), Execution Readiness ("3.3 Avg Difficulty"), Strategic Directive ("Prioritize B2B SaaS/EaaS"); Key Insights "Critical Findings" with three bullets; "Top Sectors Explored" bar chart (video 01:25).
- **States**: Populated only.
- **Navigation**: Completed tab to S3; venture card to S7; New Ideation to S6.
- **Related**: FR-004, FR-005, FR-006, FR-010, User Story 1

### S3. Completed ideations, concept list (video 00:32)

- **Purpose**: Review, rate, export, and promote concepts.
- **Layout**: Replaces the Ideations panel body when Completed is selected.
- **Components**: Header row: select-all checkbox, "0 selected", "23 concepts", Export CSV. Ideation group header: checkbox, icon, ideation title, "15 concepts", "Avg: 2.67", collapse chevron, Overall Feedback button. Concept card: checkbox, title (for example "AquaEdge: Irrigation as a Service (EaaS) for Desert Farms"), "solidified" badge, sector tag ("Precision Desert Agritech"), three-line description, two score chips at top right (star icon "4", trend icon "4"), five-star rating, "Add feedback..." input, Details (expander), Open, Create Venture & Launch Intelligence.
- **States**: Populated. Selection count updates with checkboxes (Inferred).
- **Navigation**: Create Venture & Launch Intelligence creates a venture (S7).
- **Related**: FR-011, User Story 2

### S4. Osa panel and expanded chat (video 00:17, 00:50, 01:12, 01:25, 01:30, 02:13, 02:38)

- **Purpose**: Conversational co-pilot scoped to the current project or venture.
- **Layout**: Docked card at right of S2 and S7; expands to a wide overlay covering about two thirds of the page (01:12).
- **Components**: Avatar ring, "Osa", "Connected" status, "Memory ready" chip (or "Building memory..." at 03:03), Sessions dropdown, expand and collapse icon, context line ("Orchestrator > Project: BaseLayer", "Venture: SoilSense Pro"). Message list: user messages right-aligned in green bubbles with time; Osa messages left-aligned with headings, bold, numbered and bulleted lists, inline diagram thumbnail. Quick action buttons above input: on projects New Venture, Run Ideation, Next Steps; on ventures Analyze, Match, Package. Input "Ask Osa anything..." with microphone icon.
- **States**: Empty (00:17), conversing, building memory (03:03).
- **Related**: FR-005, FR-007, FR-019

### S5. Diagram viewer (video 01:18)

- **Purpose**: Full view of an Osa-generated diagram.
- **Layout**: Large modal over the page. Title "Diagram" with a small caption (illegible). Controls at top right: zoom in, zoom out, Fit, Reset, Export SVG, Close.
- **Components**: Layered boxes with labeled nodes and arrows: "Physical Ground Truth" (Aquifer Level Sensors, Soil Salinity Probes, Facility Flow Meters into BaseLayer Edge Gateway); "BaseLayer Integrity Engine" (Data Fusion & Anomaly Detection, Hydrogeological Impact Modeling, Audit-Ready Integrity Proofs); "Strategic Deliverables" (DCIM Integration, ESG/TNFD Reporting, Regulatory Sandbox, Community Dashboard); "Primary Beneficiaries" (four nodes).
- **Related**: FR-008

### S6. New ideation form, "Frame Your Boundaries" (video 01:30, partly hidden behind S4)

- **Purpose**: Define an ideation before launch.
- **Layout**: Card titled "Frame Your Boundaries", eyebrow "Constraint-driven", subtitle "Exploration space".
- **Components**: Title field (prefilled "BaseLayer: AI-Water Nexus & Data Center Stew..."), Expert Guidance textarea (prefilled list), Exploration Constraints list (Market Focus, Technology Scope, Regulatory, each with prefilled values), Supporting Materials upload area, full-width green launch button.
- **States**: Prefilled from chat. Low confidence on exact labels: the form is mostly covered by the chat overlay.
- **Related**: FR-009

### S7. Venture page (video 01:42, 01:49, 02:27)

- **Purpose**: Workspace for one venture.
- **Layout**: Header card (name "SoilSense Pro", description, created date, "New" badge, "Part of BaseLayer" link). Four stage tiles. Intelligence Analysis. Team Matching. Pitch & Materials. Analytics (2 by 2 charts). Venture Roadmap. Venture To Do. Osa panel at right.
- **Components**: Stage tiles: icon, name, status ("Not Started", "Completed"), info icon. Intelligence Analysis: subtitle "Multi-agent AI to validate and enhance your venture", View Full Analysis, "Analysis Complete" banner with Show Summary, "Generated Documents" two-column list (icon, name, view, download), Download All. Team Matching: subtitle "Co-founders & investor matching", Find Matches button, "Intelligence Analysis Ready" notice, empty state "No matching analysis yet". Pitch & Materials: subtitle "Investor-ready documents", Generate button, "Intelligence Analysis Ready" notice, "No materials generated yet" (01:42). Analytics: Market Opportunity bars (TAM, SAM, SOM, log scale to $100B), Competitive Landscape scatter (x "Deploy Cost/Complexity", y "MRV-Grade Performance", competitors Trace Genomics, Biome Makers, Yard Stick, SoilOptix, plus SoilSense Pro as a star), Risk Assessment horizontal bars (eight risks, "Risk Score (Likelihood x Impact)"), Customer Segments bars (Carbon developers, Ag co-ops, Enterprise farms, Food/CPG, Gov/NGO; "Average Score (1-10)"). Venture Roadmap: subtitle "Journey from concept to scale", timeline Week 0 to Week 16 with draggable marker and hint "Drag the timeline indicator above to see the current week", milestone rows (icon, title, description, category chip such as Validation, Planning, Development, Team, Legal, checklist bullets, "+ Add decision", duration bar such as "2w", "3w", "4w"), legend (Completed, In Progress, Pending, Key Decision), Add Milestone. Venture To Do: subtitle "AirOS-recommended next steps", "Todo updated" badge, percent complete with progress bar, task rows (drag handle, circle checkbox, title, priority chip), done tasks struck through, Add Task.
- **States**: Stages Not Started and Completed; empty matching and materials; to-do updated.
- **Related**: FR-012 to FR-019, User Stories 3 and 4

### S8. Generate Investor Materials dialog (video 02:44, 02:53)

- **Purpose**: Configure and launch packaging.
- **Layout**: Tall lavender modal, eyebrow "Pitch & Materials", title "Generate Investor Materials", close icon.
- **Components**: Venture name field ("SoilSense Pro (Sensing Soil)"). "Venture Documents" with "Intelligence Ready" chip; Business Plan row checked; "10 other document(s) available" expandable list; "1 document(s) selected". "Packaging Requirements & Priorities" textarea (prefilled narrative) with hint "Specify pitch deck style, target investors, and key metrics to highlight". "Packaging Requirements" chips: "Pitch Requirements: 11-13 slides including the 'Value Stack' ($/ha), competitive positioning in the high-performance/low-friction quadrant, and specific use of the $1.5M seed funds", "Audience Focus: AgTech VCs, Climate Tech VCs, and Deep Tech investors", "Material Priorities: Pitch Deck, Financial Projections (ROI modeling), and Investment Memorandum". "Additional Documents (Optional)" drag and drop ("Business plan, Financials, Traction data"). Cancel and Launch Packaging (purple) buttons.
- **States**: Ready to launch; launching (02:53, button shows a spinner, Osa reply blurred while streaming).
- **Related**: FR-020, User Story 5

### S9. Pitch deck (video 02:47, 03:00)

- **Purpose**: View the generated deck.
- **Layout**: Appears to be a separate presentation editor: top bar with breadcrumb "SoilSense Pro", Theme, Share, Agent, Present; left slide rail (11 slides); right tool rail; slides in a vertical scroll.
- **Components**: Slides seen: title slide ("Real-time microbial soil intelligence for yield optimization and verification-ready carbon MRV"), "The Biological Black Hole" (four stakeholder cards, three big numbers 20-30%, $250, 12-24), "Real-time Intelligence, Verified Outcomes", "Competitive Differentiation", "Expertise to Execute" (five roles), "Path to TRL 7 & MRV Readiness" (18-month roadmap).
- **Related**: FR-021, C-2

### S10. Financial model (video 03:03)

- **Purpose**: Scenario-based financial projections.
- **Components**: Customer projections (Current Month 1: 2, Month 12: 45, Month 24: 215). "Cohorts & Retention" heat table (rows Mon 1 to Mon 5, columns Month 0, 6, 12, 18, 24, color legend Excellent 90%+ to Very Poor under 50%) with tabs All Scenarios, Base Case, Conservative, Upside. "Unit Economics" tiles with rating chips (CAC $15,000 "Poor", LTV $101,332, LTV:CAC 6.76x "Excellent", Payback 6 months "Excellent", Gross Margin 75% "Good", Revenue Retention 118.93% "Excellent") and a radar chart "Unit Economics Performance". "Key Insights" list (for example "Monthly churn rate: 1.5%", "Initial ARPU: $3,500", "Forecast Horizon: 24 months").
- **Related**: FR-022

### S11. Business plan document (video 01:56, 02:01)

- **Purpose**: The downloaded Business Plan opened in a desktop word processor (French-language UI, so the user's local app).
- **Components**: Table of contents (Executive Summary, Problem Analysis, Solution Analysis, Industry Analysis, Market Opportunity, Competitive Analysis, Marketing & Sales Strategy, Operations Plan, Financial Plan, Funding Requirements, Risk Analysis, Exit Strategy, Client Identification & Acquisition, IP Analysis & Strategy). Financial Plan page with prose and a "5-Year Revenue, Cost, and Margin (Illustrative)" combo chart. About 60 pages (status bar "Page 9 sur 60", approximate).
- **Related**: FR-014, FR-015

## Flows

### F1. Explore and launch an ideation (User Story 1)

1. (video 00:17) On S2, Osa panel docked, empty.
2. (video 00:50) User types "hey, what new directions can we explore to align with the project's goals? what do you think would be the most promising?"
3. (video 01:12) S4 expands; Osa returns four directions (AI-Water Nexus, TNFD & Biodiversity Verification, Sovereign Water Security, Parametric Infrastructure Insurance) and asks which fits.
4. (video 01:25) Osa frames "The AI-Water Nexus" (mission, key constraints) and asks to proceed. User: "before, present the most important elements in a diagram." Osa returns a diagram thumbnail and three strategic pillars.
5. (video 01:18) User opens the diagram in S5.
6. (video 01:30) User: "yes, let's move forward with the new ideation to explore associated venture concepts." Osa confirms launch; S6 visible behind the chat with prefilled fields.

### F2. Promote a concept (User Story 2)

1. (video 00:27) On S2, user clicks Completed (2).
2. (video 00:32) S3 lists 23 concepts grouped by ideation; cursor over the first concept.
3. Create Venture & Launch Intelligence creates SoilSense Pro (Inferred: the click is not shown; narration 00:28 says the project "has already spawned live concepts").

### F3. Venture summary and documents (User Story 3)

1. (video 01:33) Blurred transition to S7.
2. (video 01:42) User types "what is the venture about in a nutshell" in the Osa panel.
3. (video 01:49) Osa answers; Generated Documents list visible; cursor over Policy Appendix.
4. (video 01:56, 02:01) Business Plan opened in a word processor; user scrolls to Financial Plan.

### F4. Segment focus and to-do update (User Story 4)

1. (video 02:13) Osa ranks segments; user: "lets focus on the top segment"; Osa details Carbon Project Developers & Registries and proposes next steps. User types "I would like you to update my todo with the 5 most important tasks related to this for today, I want to get ahead".
2. (video 02:27) Venture To Do shows "Todo updated" and five new High-priority tasks prefixed [Regulatory], [Partnership], [Financial], [Technical], [Sales]; Osa lists them.

### F5. Investor angle and packaging (User Story 5)

1. (video 02:38) Osa gives the "Biological Blindness" narrative, dual-engine ROI, moat, investor shortlist, and seed milestone. User: "let's launch a packaging analysis".
2. (video 02:44) Osa asks to confirm; user "yes"; S8 opens with prefilled requirements.
3. (video 02:53) Launch Packaging pressed.
4. (video 02:47, 03:00) Pitch deck in S9.
5. (video 03:03) Financial model in S10; Osa shows "Building memory..." and next steps.

## Data model (Inferred)

### Project

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| name | string | S1 card, S2 header |
| description | text | S1 card, S2 header |
| created_at | date | "Jan 16, 2026" on S1, "Created January 16, 2026" on S2 |
| status | enum (active, archived) | S1 tabs, S2 "Active" badge |
| progress | percent | S1 card chip |
| sort_order | integer | drag handles on S1 cards |

### Ideation

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| project | reference to Project | S2 Ideations panel |
| title | string | S2 rows, S6 title |
| status | enum (draft, running, refined/completed) | "Refined" badge, Completed tab |
| expert_guidance | text | S6 |
| constraints | list of {kind, value}, kind in (market_focus, technology_scope, regulatory) | S6 |
| supporting_materials | list of files | S6 upload area |
| created_at | date | S2 rows |

### Concept

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| ideation | reference to Ideation | S3 grouping |
| title, description | string, text | S3 card |
| maturity | enum (includes solidified) | S3 badge |
| sector | string | S3 tag |
| score_a, score_b | integer 1 to 5 (C-4) | S3 chips |
| founder_rating | integer 0 to 5 | S3 stars |
| founder_feedback | text | S3 input |

### Venture

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| project | reference to Project | "Part of BaseLayer" |
| source_concept | reference to Concept | S3 action |
| name, description | string, text | S7 header |
| stage_statuses | map of stage (ideation, intelligence, matching, packaging) to (not_started, in_progress, completed) | S7 tiles |

### Generated Document

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| venture | reference to Venture | S7 list |
| kind | enum of 11 kinds | S7 list |
| file | .docx (C-3) | S11 |

### Milestone

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| title, description | string | S7 roadmap |
| category | enum (validation, planning, development, team, legal; others not shown) | S7 chips |
| checklist | list of strings | S7 bullets |
| start_week, duration_weeks | integer | S7 bars |
| status | enum (completed, in_progress, pending, key_decision) | S7 legend |

### Task

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| title | string | S7 To Do |
| priority | enum (high, medium, low) | S7 chips |
| done | boolean | struck-through rows |
| created_by | enum (founder, osa) | NFR-004 |
| sort_order | integer | drag handles |

### Osa Session and Investor Package

| Field | Inferred type | Evidence |
|-------|---------------|----------|
| session.context | reference to Project or Venture | S4 context line |
| session.messages | list of {role, content, time} | S4 |
| session.memory_status | enum (ready, building) | S4 chip |
| package.requirements | text plus chips | S8 |
| package.source_documents | list of Generated Document | S8 |
| package.deck | slides (C-2) | S9 |
| package.financial_model | scenarios (base, conservative, upside) of projections, cohorts, unit economics | S10 |

## Implementation hints

The recording reveals no stack. The pitch deck editor (S9) appears to be a separate presentation product; the downloaded business plan opens in a desktop word processor. Otherwise stack-agnostic.

## Coverage notes

- **Frames reviewed**: 26 of 26.
- **Sparse or blurry stretches**: 00:37 to 00:50 (concept cloud narrated, only the concept list is visible); 00:54 to 01:10 (Osa reply composed off screen); 01:33 and 02:03 are motion-blurred transitions, reconstructed from narration; the concept-to-venture click is not shown.
- **Low-confidence reads**: product name in the top bar ("airos.operatingsystem"); S6 field labels; S9 slide text below headings; document page count.
