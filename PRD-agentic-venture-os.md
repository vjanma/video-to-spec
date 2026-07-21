# PRD: Agentic Venture Operating System (AVOS)

> Generated from https://www.youtube.com/watch?v=nGH5mxbcDm4 (03:15) on 2026-07-21.
> Timestamps like (video MM:SS) reference the source recording.

## 1. Overview

The **Agentic Venture Operating System** (AVOS, branded in-product as "OS") is a
web application for a solo operator — addressed as "Founder" — to move "from
insight to action—at the n-th speed" (video 00:00). It manages a portfolio of
early-stage venture initiatives through a strict maturity hierarchy: **Projects**
contain **Ideations/Concepts**, which are promoted into fully instantiated
**Ventures** (video 00:09–01:36). The product's core promise is that an AI
co-pilot orchestrates the "heavy lifting" of venture creation — research,
strategy, document generation, and investor packaging — that a founder would
otherwise do manually (video 01:49).

The central intelligence layer is **OSA**, described as "your strategic co-pilot"
that can "command a fleet of over 100 specialized agents" (video 00:54). OSA is
invoked conversationally to scan a project's underlying data, propose
high-leverage opportunities, generate system architecture, identify target
customer segments, rewrite the venture's daily agenda, synthesize investor
narratives, and compile a pitch deck with financial models (video 00:51–03:08).

The video is a scripted product demo (a "sizzle reel") narrated in the first
person, walking through one end-to-end story: starting from a project called
**BaseLayer**, exploring a soil-sensing concept, and instantiating a venture
called **SoilSense Pro**, then refining its strategy and generating its investor
materials. It is aimed at founders and venture builders who want an AI-native
workspace that carries an idea from raw concept to investment-ready package.

Because this is a demo reel with fast cuts and heavy motion, several screens
(the Concept Cloud, the architecture-generation step, the to-do list) are
*narrated but not clearly shown in a stable keyframe*. Those requirements are
marked **Inferred** and carry Open Questions where the exact UI is unresolved.

## 2. Goals & Non-Goals

**Goals**

- Provide a portfolio dashboard summarizing the founder's entire venture
  ecosystem at a glance (Projects, Ideations, Generated Concepts, Ventures).
- Model a three-tier hierarchy: Project → Concept (Ideation) → Venture.
- Let the founder explore and filter raw concepts by technical feasibility and
  market viability.
- Provide a conversational AI co-pilot (OSA) that acts on the founder's
  data — proposing opportunities, generating architecture, identifying
  customer segments, updating the agenda/to-do list, and producing investor
  materials.
- Auto-generate a venture's intelligence assets (business plan, IP appendix,
  and other appendices) when a venture is instantiated.
- Auto-generate an investor pitch deck and financial projections from the
  venture's data, driven by an AI-synthesized narrative.
- Surface each venture's analytics (market opportunity, competitive landscape,
  risk assessment, customer segments) and a team-matching capability.

**Non-Goals** (not shown or described in the video)

- No authentication, sign-up, billing, or account-management flows are shown
  (the app opens already signed in as "Founder").
- No multi-user collaboration, sharing permissions, or commenting is
  demonstrated (a "Share" control exists on the deck view but is not exercised).
- No real integrations with external data sources, CRMs, or investor databases
  are shown; data appears to be internally generated.
- No editing of individual generated documents is demonstrated (they are opened
  and reviewed, not edited).
- No export/download of the pitch deck or documents is demonstrated (a
  "Present" control exists but export is not shown).
- No settings, theme configuration (a "Theme" control is visible but unused), or
  admin surfaces are demonstrated.
- The underlying agent-orchestration mechanics ("fleet of 100+ agents") are a
  narrative claim, not a shown feature — no agent-monitoring UI appears.

## 3. Users & Roles

The video shows a single user type.

| Role | Description | Key capabilities |
| --- | --- | --- |
| Founder | The sole operator of the system; owns all projects and ventures. Addressed as "Founder" on the dashboard (video 00:00). | View portfolio dashboard; create/open projects; explore concepts; converse with OSA; instantiate ventures; review generated documents; trigger pitch/financials generation; view venture analytics. |

There is no evidence of any other role (admin, collaborator, investor viewer).
Any need for additional roles is an Open Question (see §10).

## 4. Functional Requirements

### FR-1: Portfolio dashboard with ecosystem metrics
- **Description:** Display a landing dashboard titled "Welcome back, Founder"
  with the subtitle "Your venture ecosystem at a glance," showing four
  aggregate metric cards. (video 00:00)
- **Behavior:** On load, the dashboard renders four stat cards in a row:
  **Projects** (value 18, "18 active · 0 archived"), **Ideations** (value 82,
  "across all projects"), **Generated Concepts** (value 4123, "from completed
  ideations"), and **Ventures** (value 38, "across all projects"). Each card
  shows a small upward trend line chart and a percentage delta badge
  (+12%, +12%, +16%, +9% respectively). Below the cards is the "Your Projects"
  section.
- **Acceptance criteria:**
  - Given the founder opens the app, when the dashboard loads, then four metric
    cards labeled Projects, Ideations, Generated Concepts, and Ventures are
    visible with a numeric value, a sublabel, a trend sparkline, and a delta
    badge each.
  - Given the metric values, when rendered, then each card's value matches the
    corresponding aggregate count derived from the founder's data.
  - Given the dashboard, when it renders, then a greeting "Welcome back,
    Founder" and subtitle "Your venture ecosystem at a glance" appear above the
    cards.
- **Source:** Observed (values and labels visible in keyframe 00:00).

### FR-2: Project list with Active/Archived tabs
- **Description:** Under "Your Projects" ("Organize and track your venture
  initiatives"), display the founder's projects as cards, filterable by an
  "Active" / "Archived" tab control. (video 00:00)
- **Behavior:** A tab row shows "Active (18)" and "Archived (0)". The Active tab
  is selected by default and lists project cards in a responsive grid. A green
  "+ New Project" button sits at the top-right of the section. Each project card
  shows: project name, a creation/updated date (e.g. "Jan 21, 2026"), a
  one-line description, a row of metric chips (idea count, concept count with a
  percentage, venture count with a maturity percentage), and an "Open Project →"
  button. Observed project cards include: **BaseLayer** ("The foundational data
  infrastructure for the planet's natural capital. BaseLayer provides the
  'Ground Trut…'"), **MediDTX** ("Based on the MDTX flagship project"),
  **AI workforce operating system**, **Project Alpha**, **Carbon-to-industrial
  inputs…**, and **Reskilling as infrastructure…** (all "A new venture project").
- **Acceptance criteria:**
  - Given the dashboard, when it renders, then a tab control labeled "Active (N)"
    and "Archived (M)" appears with Active selected by default.
  - Given active projects exist, when the Active tab is selected, then each
    project renders a card with name, date, description, metric chips, and an
    "Open Project" action.
  - Given the founder clicks "+ New Project", then a project-creation affordance
    opens. (creation flow itself not shown — see Open Questions)
  - Given the Archived tab shows count 0, when selected, then an empty state is
    displayed.
- **Source:** Observed (cards and tabs visible in keyframe 00:00); the create
  flow behind "+ New Project" is Inferred.

### FR-3: Project as a container of concepts and ventures
- **Description:** A Project is "a living container for exploration" (video 00:18)
  that holds child Concepts and Ventures and displays its own maturity. A project
  (BaseLayer) has "already spawned live concepts like AquEdge and AquaSoil"
  (video 00:26–00:33). (video 00:09–00:34)
- **Behavior:** Opening a project shows its maturity indicators and its child
  concepts/ventures. In the narration, BaseLayer's "data foundation is solid,"
  indicating a project-level readiness/maturity signal. Named child concepts
  (AquEdge, AquaSoil) are surfaced as "live concepts" that originated from the
  project.
- **Acceptance criteria:**
  - Given a project, when opened, then its child concepts and any spawned
    ventures are listed under it.
  - Given a project has spawned ventures, when displayed, then a maturity
    indicator (percentage) is shown, consistent with the dashboard card's
    venture-maturity chip.
  - Given a concept was promoted to a live venture, when the project is viewed,
    then that concept is labeled as "live."
- **Source:** Observed (narration + dashboard chips); the project *detail*
  screen is Inferred (no stable keyframe of the opened project).

### FR-4: Concept Cloud — explore and filter raw concepts
- **Description:** A "concept cloud" view visualizes "hundreds of raw concepts,
  filtering them in real time by technical feasibility and market viability" to
  find a promising signal. (video 00:37–00:47)
- **Behavior:** The founder enters the Concept Cloud from a project. Many concept
  nodes are displayed simultaneously. Two filter dimensions — **technical
  feasibility** and **market viability** — adjust the visible set in real time as
  the founder changes them. The goal is to isolate a "new signal" (a promising
  concept) from the "noise."
- **Acceptance criteria:**
  - Given the Concept Cloud is open, when it renders, then multiple concept
    nodes are shown together in a single view.
  - Given the founder adjusts the technical-feasibility filter, when the value
    changes, then the visible concept set updates without a full page reload.
  - Given the founder adjusts the market-viability filter, when the value
    changes, then the visible concept set updates in real time.
- **Source:** Inferred (narrated at 00:37–00:47; no clear stable keyframe — the
  transition frame at 02:03 is motion-blurred). Exact visualization form is an
  Open Question.

### FR-5: OSA co-pilot — propose high-leverage opportunities
- **Description:** OSA is a conversational strategic co-pilot the founder engages
  to "explore a new vector" (here, soil sensing). OSA "scans the base layer data
  and proposes high-leverage opportunities instantly." (video 00:51–01:08)
- **Behavior:** The founder issues a natural-language instruction to OSA (e.g.
  explore a new vector in soil sensing). OSA reads the current project's
  underlying data ("base layer data") and returns a set of proposed
  opportunities ranked by leverage. OSA is presented as commanding "a fleet of
  over 100 specialized agents" — this is a capability claim, not a visible agent
  dashboard.
- **Acceptance criteria:**
  - Given a project context, when the founder asks OSA to explore a vector, then
    OSA returns one or more proposed opportunities grounded in that project's
    data.
  - Given OSA responds, when the proposals render, then they are ordered or
    labeled by leverage/priority.
  - Given the founder is in a project, when OSA is invoked, then OSA's responses
    are scoped to that project's data.
- **Source:** Observed (narration); the OSA conversational panel is Observed in
  the venture context (keyframes 02:48, 03:01) — see FR-9.

### FR-6: OSA generates system architecture ("integrity engine")
- **Description:** On request, OSA maps the "system logic" of a concept,
  generating an architecture called the "integrity engine" that "validates the
  flow from physical ground truth to data fusion, ensuring the tech stack is
  viable." (video 01:11–01:27)
- **Behavior:** The founder asks OSA to "map the system logic." OSA generates a
  visual architecture/flow diagram representing the concept's technical pipeline
  (from "physical ground truth" data capture through "data fusion"), and
  presents a viability validation of the tech stack.
- **Acceptance criteria:**
  - Given a concept, when the founder asks OSA to map the system logic, then OSA
    produces an architecture artifact for that concept.
  - Given the architecture is generated, when displayed, then it depicts an
    ordered flow of stages (e.g. ground-truth capture → data fusion).
  - Given the architecture, when generated, then a tech-stack viability
    assessment accompanies it.
- **Source:** Inferred (narrated at 01:11–01:27; the generation animation is not
  captured in a stable keyframe). Diagram format is an Open Question.

### FR-7: Commit a concept — instantiate a Venture ("launch the ideation live")
- **Description:** With the architecture validated, the founder commits: "we
  launch the ideation live," which "instantiates a dedicated venture." The
  resulting venture is SoilSense Pro. (video 01:27–01:36)
- **Behavior:** A commit/launch action promotes the explored concept into a
  first-class Venture with its own dedicated workspace. Upon instantiation, the
  system automatically kicks off generation of the venture's intelligence assets
  (see FR-8). A welcome state ("Welcome to Soil Sense Pro") confirms the new
  venture.
- **Acceptance criteria:**
  - Given a validated concept, when the founder commits/launches it, then a new
    Venture entity is created and its dedicated workspace opens.
  - Given a venture is instantiated, when creation completes, then a
    confirmation state naming the venture is shown.
  - Given a venture is instantiated, when created, then asset-generation (FR-8)
    begins automatically without a further manual step.
- **Source:** Observed (narration + SoilSense Pro workspace keyframes).

### FR-8: Auto-generated venture intelligence assets
- **Description:** When a venture is instantiated, the OS "orchestrates the heavy
  lifting" and generates intelligence assets, including an **IP appendix** and an
  **institutional-grade business plan**; a venture **summary** is available on
  request. (video 01:36–02:06)
- **Behavior:** The venture workspace's left navigation lists "Generated
  Documents," observed to include: **Vertical Report**, **Macroeconomic
  Appendix**, **Business Intelligence Appendix**, **Client Identification
  Appendix**, **Startup Landscape Appendix**, and **Business Plan** (keyframe
  02:48). Each document has a "ready" state and can be opened for review. Asking
  OSA "for a summary" returns a concise venture description ("Soil Sense is an
  agtech AI platform providing real-time microbial soil intelligence").
- **Acceptance criteria:**
  - Given a newly instantiated venture, when generation completes, then a
    "Generated Documents" list is populated with at least a Business Plan and the
    observed appendices, each marked ready.
  - Given a generated document, when the founder opens it, then its content is
    displayed for review.
  - Given the founder asks OSA for a summary, when OSA responds, then a
    one-paragraph venture summary is returned.
- **Source:** Observed (document list visible in keyframe 02:48; summary
  narrated).

### FR-9: OSA conversational panel within a venture
- **Description:** Inside a venture, OSA appears as a right-side chat panel that
  answers strategy questions and returns structured, sectioned recommendations
  grounded in the venture's data. (video 02:06–03:08; keyframes 02:48, 03:01)
- **Behavior:** The panel header shows "OSA / Connected" with a "Memory ready"
  indicator and a "Sessions" control. The founder types requests into an input
  at the bottom (observed placeholder-style entries: "let's launch a packaging
  analysis"), and OSA returns a long structured message. One observed response is
  titled with a strategic recommendation broken into numbered sections:
  "1. The Narrative Hook: 'The Biological Black Hole'", "2. Sell the 'Dual-Engine'
  ROI", "3. The 'Moat' is the Data, not the Device", "4. Tailor the Pitch to your
  Investor Shortlist", "5. The 'Seed' Milestone ($1.5M)", and a "Next Best
  Actions" list (keyframe 02:48). A later response is titled "Your Updated
  Strategic Flow" with a "Next Steps" list (keyframe 03:01). Below the input are
  quick-action buttons observed as "Analyze", "Watch", and "Package".
- **Acceptance criteria:**
  - Given a venture is open, when the workspace loads, then an OSA chat panel is
    docked to the right showing a connected status and a message input.
  - Given the founder submits a request, when OSA responds, then the response is
    rendered as structured sections (headed subsections and/or a "Next Steps"
    list) rather than a single unbroken paragraph.
  - Given OSA's responses, when generated, then they reference the specific
    venture's data (segments, financials, narrative).
  - Given the quick-action buttons (Analyze / Watch / Package), when one is
    clicked, then the corresponding action is initiated (Package triggers FR-13).
- **Source:** Observed (keyframes 02:48, 03:01).

### FR-10: OSA identifies top target customer segments
- **Description:** The founder asks OSA to identify the venture's top clients;
  OSA "immediately flags carbon project developers as our number one target
  segment." (video 02:06–02:13)
- **Behavior:** On request, OSA analyzes the venture and returns a ranked list of
  target customer segments with the #1 segment highlighted. The founder can
  "agree" to accept the recommendation, which feeds subsequent strategy updates
  (FR-11). The venture's analytics area also renders a "Customer Segments"
  breakdown (keyframe 03:01).
- **Acceptance criteria:**
  - Given a venture, when the founder asks OSA to identify top clients, then OSA
    returns a ranked list of customer segments.
  - Given the ranked list, when displayed, then the highest-priority segment
    (e.g. "carbon project developers") is clearly marked as #1.
  - Given the founder accepts the recommendation, when confirmed, then downstream
    strategy artifacts (agenda/to-do, FR-11) update to reflect it.
- **Source:** Observed (narration; Customer Segments chart visible at 03:01).

### FR-11: OSA updates the daily agenda and venture to-do list
- **Description:** The founder asks OSA to "update our daily agenda to focus
  entirely on this value proposition." The OS "autonomously updates the
  workflow, adding the MRV cost-benefit audit task" to the venture to-do list.
  (video 02:16–02:35)
- **Behavior:** OSA rewrites the founder's daily agenda to center on the accepted
  value proposition. As a result, the **venture to-do list** is autonomously
  modified — a new task ("MRV cost-benefit audit") is appended so the founder
  "knows exactly what to focus on." The change is shown updating live in the
  to-do list.
- **Acceptance criteria:**
  - Given an accepted value proposition, when the founder asks OSA to update the
    daily agenda, then the agenda is rewritten to focus on that proposition.
  - Given the agenda update, when it completes, then the venture to-do list gains
    at least one new task derived from the new focus (e.g. "MRV cost-benefit
    audit").
  - Given the to-do list updates, when it changes, then the update is reflected
    without the founder manually adding the task.
- **Source:** Observed (narration); the agenda/to-do UI is Inferred (not clearly
  isolated in a keyframe) — see Open Questions.

### FR-12: OSA synthesizes an investor narrative and angle
- **Description:** The founder asks OSA "for the optimal investor angle given our
  specific venture data." OSA "synthesizes the biological black hole narrative,
  positioning our lack of soil data as the market's critical gap." (video
  02:35–02:52)
- **Behavior:** OSA analyzes the venture's data and produces a recommended
  investor positioning narrative (here, "The Biological Black Hole"), framing the
  absence of high-fidelity biological soil data as the market's critical gap.
  This narrative becomes the spine of the generated pitch deck (FR-13).
- **Acceptance criteria:**
  - Given a venture, when the founder asks OSA for the optimal investor angle,
    then OSA returns a named narrative/positioning grounded in the venture's data.
  - Given the narrative, when produced, then it is reusable as the organizing
    theme of the pitch deck.
  - Given the narrative names a market gap, when displayed, then it explains why
    the venture is positioned to fill it.
- **Source:** Observed (narration; the "Biological Black Hole" appears as a deck
  slide in keyframes 02:46–02:57).

### FR-13: Generate investor packaging — pitch deck + financial models
- **Description:** The founder "triggers the packaging generation." The OS
  "instantly compiles a design-perfect pitch deck centered on that exact
  narrative, backed by stress-tested financial models that adapt to every
  scenario." (video 02:52–03:08)
- **Behavior:** Triggering packaging (e.g. the "Package" quick action, FR-9)
  generates a multi-slide pitch deck themed around the OSA narrative, plus a set
  of financial projections. The deck opens in a presentation view (keyframes
  02:46–03:00) with a slide thumbnail rail on the left, a top toolbar ("Theme",
  "Share", "Agent", "Present"), and per-slide navigation. Observed slides
  include: a **title slide** ("SoilSense Pro — Real-time microbial soil
  intelligence for yield optimization and verification-ready carbon MRV"); **"The
  Biological Black Hole"** (a "Critical Gap" slide with four segment columns —
  Carbon Developers, Producers, Food & Ag Majors, Regulators — and three headline
  stats: "20–30% Yield Uplift Potential", "$250 Per Hectare Value", "12–24 Months
  to Credit"); **"Real-time Intelligence, Verified Outcomes"** (feature rows:
  Continuous Sensing, AI Analytics, MRV Ready, Dual Value Stack, Operational
  Cadence); **"Converging Trillion-Dollar Markets"**; **"Expertise to Execute"**
  (team roles: CEO, CTO, Head of Data Science, Head of Operations, Head of MRV);
  and **"Path to TRL 7 & MRV Readiness"** (a phased timeline: Months 0–6, 6–12,
  12–18). In the venture workspace, "Pitch & Materials" lists a **Pitch Deck**
  (status "Live") and **Financial Projections** (keyframe 03:01).
- **Acceptance criteria:**
  - Given an investor narrative exists, when the founder triggers packaging
    generation, then a multi-slide pitch deck themed around that narrative is
    produced and opens in a presentation view.
  - Given the deck is generated, when opened, then a left slide-thumbnail rail,
    slide navigation, and a top toolbar (Theme, Share, Agent, Present) are shown.
  - Given packaging is triggered, when it completes, then a Financial Projections
    artifact is also produced and listed under "Pitch & Materials."
  - Given the deck, when rendered, then its content reflects the venture's data
    (segments, stats, team, roadmap) rather than placeholder text.
- **Source:** Observed (deck keyframes 02:46–03:00; Pitch & Materials list 03:01).

### FR-14: Venture analytics dashboard
- **Description:** The venture workspace includes an analytics section
  visualizing the venture's market and risk profile. (video ~03:01; keyframe 03:01)
- **Behavior:** Below "Pitch & Materials," an "Analytics" section renders four
  charts: **Market Opportunity** (a TAM/SAM/SOM horizontal bar chart),
  **Competitive Landscape** (a scatter plot of competitors), **Risk Assessment**
  (a horizontal bar chart), and **Customer Segments** (a horizontal bar chart).
- **Acceptance criteria:**
  - Given a venture, when the workspace is scrolled to Analytics, then charts for
    Market Opportunity, Competitive Landscape, Risk Assessment, and Customer
    Segments are displayed.
  - Given the Market Opportunity chart, when rendered, then it shows TAM, SAM, and
    SOM tiers.
  - Given the charts, when rendered, then they reflect the specific venture's
    computed data.
- **Source:** Observed (keyframe 03:01; some labels are small/blurred — exact
  values are Inferred).

### FR-15: Team matching
- **Description:** The venture workspace provides a "Team Matching" capability to
  find people ("Find Matches") for the venture. (keyframe 03:01)
- **Behavior:** A "Team Matching" section shows an "Intelligence Analysis Ready"
  state and a green "Find Matches" button. Before matching runs, it shows an
  empty state ("No matching analysis yet"). Running it surfaces candidate
  team members aligned to the venture (the deck's "Expertise to Execute" roles —
  CEO, CTO, Head of Data Science, Head of Operations, Head of MRV — indicate the
  role taxonomy).
- **Acceptance criteria:**
  - Given a venture, when the workspace loads, then a "Team Matching" section with
    a "Find Matches" action is shown.
  - Given no matching has run, when the section renders, then an empty state is
    displayed.
  - Given the founder clicks "Find Matches", when analysis completes, then
    candidate matches for the venture's needed roles are listed.
- **Source:** Observed (keyframe 03:01); match *results* UI is Inferred.

## 5. Screen-by-Screen UI Specification

### 5.1 Portfolio Dashboard (video 00:00)
- **Purpose:** The founder's home; a portfolio overview of the entire venture
  ecosystem and entry point into projects.
- **Layout (top → bottom):**
  1. **Top bar:** app location/breadcrumb at far left (reads like
     "os.avos/system"), a "Home" link at far right.
  2. **Hero band:** centered OS ring logo, wordmark "OS", label "AGENTIC VENTURE
     OPERATING SYSTEM", tagline "From insight to action—at the n-th speed," on a
     pale-green gradient with abstract green torus artwork on both sides.
  3. **Greeting:** "Welcome back, Founder" (large heading) + subtitle "Your
     venture ecosystem at a glance."
  4. **Metric cards row:** four cards — Projects (18), Ideations (82), Generated
     Concepts (4123), Ventures (38) — each with a sublabel, an upward sparkline,
     and a green percentage-delta badge (+12% / +12% / +16% / +9%).
  5. **Projects section:** header "Your Projects" + subtitle "Organize and track
     your venture initiatives," with a green "+ New Project" button at the right.
  6. **Tabs:** "Active (18)" (selected) and "Archived (0)".
  7. **Project cards grid:** two-plus columns of cards (BaseLayer, MediDTX, AI
     workforce operating system, Project Alpha, Carbon-to-industrial inputs…,
     Reskilling as infrastructure…), each with name, date, description, metric
     chips, and "Open Project →".
- **Components:** "+ New Project" button (opens project creation); "Open Project"
  buttons (navigate to project detail); Active/Archived tabs (filter list);
  "Home" link.
- **States:** Populated (shown). Archived tab empty state (count 0). Loading and
  error states Inferred.
- **Navigation:** App root. From here → project detail (Open Project) or project
  creation (+ New Project).
- **Visual style:** Light theme, sage/emerald green accent palette, generous
  whitespace, rounded cards, subtle line-chart sparklines.

### 5.2 Project Detail (video 00:09–00:34) — *Inferred layout*
- **Purpose:** The "living container for exploration" for one project; shows
  maturity and the concepts/ventures it has spawned.
- **Layout:** Project header with name and maturity indicator; a list/grid of
  child concepts (e.g. AquEdge, AquaSoil) with "live" badges where promoted; entry
  point into the Concept Cloud.
- **Components:** concept cards; an affordance to open the Concept Cloud; OSA
  invocation.
- **States:** Populated with concepts; maturity displayed. Empty state (new
  project, no concepts) Inferred.
- **Navigation:** Arrived from dashboard "Open Project." Leads to Concept Cloud
  and to OSA-driven exploration.
- **Note:** No stable keyframe isolates this screen; layout is Inferred from
  narration and the dashboard's project-card metrics.

### 5.3 Concept Cloud (video 00:37–00:47) — *Inferred layout*
- **Purpose:** Visualize hundreds of raw concepts and filter to a promising
  signal.
- **Layout:** A large canvas of concept nodes with filter controls for
  "technical feasibility" and "market viability" that re-filter in real time.
- **Components:** concept nodes (selectable); two filter sliders/controls;
  possibly a detail panel on selection (Inferred).
- **States:** Dense/populated; filtered subset; empty (no matching concepts)
  Inferred.
- **Navigation:** Entered from a project; selecting a concept leads into OSA
  exploration/architecture generation.
- **Note:** Only a motion-blurred transition frame (02:03) exists; visualization
  form is an Open Question.

### 5.4 Venture Workspace (video 01:33–03:08; keyframes 02:48, 03:01)
- **Purpose:** The dedicated home for one instantiated venture (SoilSense Pro),
  aggregating generated documents, team matching, materials, analytics, and the
  OSA co-pilot.
- **Layout (left → right):**
  1. **Left sidebar / nav:** venture identity ("SoilSense Pro"), an "Intelligence
     Analysis / Analysis Complete" status, and a "Generated Documents" list
     (Vertical Report, Macroeconomic Appendix, Business Intelligence Appendix,
     Client Identification Appendix, Startup Landscape Appendix, Business Plan).
  2. **Main content (scrolling):** section blocks in order — Intelligence
     Analysis, Generated Documents, **Team Matching** (with "Find Matches"),
     **Pitch & Materials** (Pitch Deck — "Live"; Financial Projections),
     **Analytics** (Market Opportunity, Competitive Landscape, Risk Assessment,
     Customer Segments).
  3. **Right OSA panel:** header "OSA / Connected" + "Memory ready" +
     "Sessions"; scrollable conversation of structured recommendations; a message
     input at the bottom with quick-action buttons "Analyze", "Watch", "Package".
- **Components:** document rows (open to review); "Find Matches" button; "View
  Materials" link; per-material action buttons ("Live"/"Data"); OSA input +
  quick-action buttons; charts.
- **States:** Populated (shown). Team Matching empty state ("No matching analysis
  yet"). Generating states while OSA works (Inferred).
- **Navigation:** Arrived by instantiating/opening a venture. "View Materials" /
  the Pitch Deck lead to the Pitch Deck Presentation view (5.5).

### 5.5 Pitch Deck Presentation View (video 02:46–03:00)
- **Purpose:** View and present the auto-generated investor pitch deck.
- **Layout:**
  1. **Top toolbar:** venture name at left; "Theme", "Share", "Agent" controls,
     and a prominent "Present" button at right.
  2. **Left rail:** vertical thumbnail strip of all slides (scrollable) with the
     OS logo pinned at the bottom.
  3. **Main stage:** the current slide, full-width, with slide-navigation controls
     (prev/next, and a bottom control cluster) and a right-edge next-slide arrow.
- **Observed slides:** Title ("SoilSense Pro"); "The Biological Black Hole"
  (Critical Gap: Carbon Developers / Producers / Food & Ag Majors / Regulators;
  stats 20–30% Yield Uplift, $250 Per Hectare Value, 12–24 Months to Credit);
  "Real-time Intelligence, Verified Outcomes" (Continuous Sensing, AI Analytics,
  MRV Ready, Dual Value Stack, Operational Cadence); "Converging Trillion-Dollar
  Markets"; "Expertise to Execute" (CEO, CTO, Head of Data Science, Head of
  Operations, Head of MRV); "Path to TRL 7 & MRV Readiness" (Months 0–6 / 6–12 /
  12–18 milestone timeline).
- **Components:** slide thumbnails (jump to slide); Present button (enter
  full-screen presentation — behavior Inferred); Theme (restyle deck — Inferred);
  Share (Inferred, not exercised); slide nav controls.
- **States:** Populated deck (shown). Generating/empty states Inferred.
- **Navigation:** Opened from the venture's "Pitch & Materials" / "View Materials."
- **Visual style:** Dark-green slide canvas with high-contrast typography and
  category color chips (green/blue/amber). Note the deck view is dark-themed while
  the app chrome remains light.

### 5.6 Closing Brand Screen (video 03:12) — demo-only
- **Purpose:** Sizzle-reel outro; not an app screen. Shows the OSⁿ logo, "Agentic
  Venture Operating System," and tagline "Intelligence, Orchestrated. Ventures,
  Realized." Documented for completeness; **not a requirement** to build.

## 6. User Flows

**Flow A — Portfolio to Project (video 00:00–00:34)**
1. Founder lands on the Portfolio Dashboard (00:00). →
2. Reviews ecosystem metrics (Projects/Ideations/Concepts/Ventures). →
3. Clicks "Open Project" on BaseLayer. →
4. Project detail shows maturity and spawned live concepts (AquEdge, AquaSoil)
   (00:26–00:33).

**Flow B — Concept exploration to Venture instantiation (video 00:37–01:36)**
1. From the project, Founder opens the Concept Cloud (00:37). →
2. Filters concepts by technical feasibility & market viability to find a signal
   (00:42–00:47). →
3. Engages OSA to explore a soil-sensing vector; OSA proposes high-leverage
   opportunities from base-layer data (00:51–01:08). →
4. Asks OSA to "map the system logic"; OSA generates the "integrity engine"
   architecture and validates the tech stack (01:11–01:27). →
5. Commits — "launch the ideation live" — instantiating the SoilSense Pro venture
   (01:27–01:36).

**Flow C — Venture asset review (video 01:36–02:06)**
1. SoilSense Pro workspace opens; OS has auto-generated assets. →
2. Founder asks OSA for a summary; OSA returns the venture one-liner. →
3. Founder opens generated documents — IP appendix, business plan, and other
   appendices — to review (02:00–02:06).

**Flow D — Strategy refinement (video 02:06–02:35)**
1. Founder asks OSA to identify top clients; OSA flags "carbon project
   developers" as #1 (02:06–02:13). →
2. Founder agrees and asks OSA to update the daily agenda around this value
   proposition (02:16–02:19). →
3. The venture to-do list autonomously gains an "MRV cost-benefit audit" task
   (02:29–02:35).

**Flow E — Investor packaging (video 02:35–03:08)**
1. Founder asks OSA for the optimal investor angle (02:38–02:41). →
2. OSA synthesizes the "Biological Black Hole" narrative (02:44–02:52). →
3. Founder triggers packaging generation (02:52–02:55). →
4. OS compiles the pitch deck around the narrative plus stress-tested financial
   models; deck opens in the presentation view (02:55–03:08).

## 7. Data Model (Inferred)

All entities below are **Inferred** from UI and narration; fields note the
evidencing screen(s).

- **Project** *(Inferred)* — dashboard cards (5.1), project detail (5.2)
  - `id`, `name` (e.g. "BaseLayer")
  - `description` (one-line, e.g. "The foundational data infrastructure…")
  - `createdOrUpdatedDate` (e.g. 2026-01-21)
  - `status` (active | archived)
  - `ideaCount`, `conceptCount`, `conceptCompletionPct`, `ventureCount`,
    `ventureMaturityPct` (from card chips)
  - relationships: has many **Concept**, has many **Venture**

- **Concept (Ideation)** *(Inferred)* — Concept Cloud (5.3), project detail
  - `id`, `name` (e.g. "AquEdge", "AquaSoil"), `projectId`
  - `technicalFeasibilityScore`, `marketViabilityScore` (filter dimensions)
  - `status` (raw | live/promoted)
  - `architecture` (the "integrity engine" artifact, when generated)
  - relationship: may be promoted into one **Venture**

- **Venture** *(Inferred)* — venture workspace (5.4)
  - `id`, `name` (e.g. "SoilSense Pro"), `projectId`, `sourceConceptId`
  - `summary` (one-paragraph, OSA-generated)
  - `maturityPct`
  - relationships: has many **GeneratedDocument**, one **PitchDeck**, one
    **FinancialProjection**, many **CustomerSegment**, one **Agenda**, one
    **TodoList**, analytics datasets, team-match results

- **GeneratedDocument** *(Inferred)* — Generated Documents list (5.4)
  - `id`, `ventureId`, `type` (Vertical Report | Macroeconomic Appendix |
    Business Intelligence Appendix | Client Identification Appendix | Startup
    Landscape Appendix | Business Plan | IP Appendix)
  - `status` (generating | ready), `content`

- **CustomerSegment** *(Inferred)* — OSA response + Customer Segments chart (5.4)
  - `id`, `ventureId`, `name` (e.g. "Carbon Project Developers"),
    `priorityRank`, `value`

- **TodoTask** *(Inferred)* — venture to-do list (FR-11)
  - `id`, `ventureId`, `title` (e.g. "MRV cost-benefit audit"), `source`
    (manual | osa-generated), `done`

- **PitchDeck** *(Inferred)* — presentation view (5.5)
  - `id`, `ventureId`, `narrative` (e.g. "The Biological Black Hole"),
    `status` (generating | live), `slides[]`
  - **Slide** — `order`, `title`, `layoutType`, `content` (segments, stats,
    features, team, timeline)

- **FinancialProjection** *(Inferred)* — Pitch & Materials (5.4)
  - `id`, `ventureId`, `scenarios[]` ("stress-tested… adapt to every scenario")

- **TeamMatch** *(Inferred)* — Team Matching (5.4) + deck team slide
  - `id`, `ventureId`, `role` (CEO | CTO | Head of Data Science | Head of
    Operations | Head of MRV), `candidate`, `matchScore`

- **OsaSession / Message** *(Inferred)* — OSA panel (5.4)
  - session with "memory"; messages typed by founder; structured responses with
    titled sections and "Next Steps"

- **EcosystemMetrics** *(Inferred/derived)* — dashboard (5.1)
  - aggregate counts: projects, ideations, generatedConcepts, ventures; each with
    a trend series and a period-over-period delta %

## 8. Non-Functional Requirements

- **Platform:** Responsive web application, viewed in a desktop browser
  (chrome/breadcrumb visible at 00:00). No mobile layout is demonstrated.
- **Theming:** A "Theme" control exists in the deck toolbar (5.5). The app chrome
  is light-themed; the pitch deck canvas is dark-themed. Light/dark support is
  implied but not exercised.
- **Persistence:** Portfolio, projects, ventures, generated documents, and OSA
  session "memory" ("Memory ready," 02:48) persist across the session.
- **Performance/perceived speed:** The product's positioning emphasizes speed —
  "at the n-th speed," OSA proposes opportunities "instantly," the OS "instantly
  compiles" the deck (00:00, 01:06, 02:55). Generation actions should present
  immediate feedback and a progress/ready state. Real-time filtering in the
  Concept Cloud is a stated behavior (00:42).
- **AI generation:** Core value depends on an LLM/agent backend that generates
  documents, architecture, narratives, decks, and financial models from venture
  data. The "fleet of 100+ agents" is a narrative framing, not a required visible
  architecture.
- **Auth:** Not shown; app opens already authenticated as "Founder."

## 9. Suggested Implementation Notes

- The video reveals **no** framework or backend specifics; the PRD is
  **stack-agnostic**. Do not infer a stack from the UI.
- The UI is a data-dense dashboard app with charts (sparklines, bar charts,
  scatter plots), a card grid, a slide-deck presentation view, and a docked
  conversational panel — any modern SPA stack with a charting library suffices.
- The generative features (documents, architecture diagram, narrative, deck,
  financial models) require an LLM/agent orchestration layer. Treat OSA as a
  server-side agent service that reads venture data and returns structured JSON
  the UI renders — the structured, sectioned OSA responses (5.4) suggest a
  schema-constrained output contract rather than free text.
- Build the three-tier data hierarchy (Project → Concept → Venture) first; every
  other feature hangs off it.
- The pitch deck is best modeled as structured slide data (title, layoutType,
  content), rendered by the app, rather than as opaque exported files — this
  matches the observed themeable, navigable presentation view.

## 10. Open Questions & Assumptions

| # | Question / Gap | Why it matters | Recommended default |
| --- | --- | --- | --- |
| 1 | What does the "+ New Project" flow collect (name, description, seed data source)? Not shown. | Blocks building project creation. | Modal collecting name + one-line description + optional "foundational data" source; creates an empty Active project. |
| 2 | Exact Concept Cloud visualization (force-directed graph? scatter by the two axes? tag cloud?). Only a blurred frame exists. | Determines a core screen's build. | 2-axis scatter/bubble canvas: X = technical feasibility, Y = market viability, bubble = concept; two range sliders filter in real time. |
| 3 | Form of the "integrity engine" architecture artifact (node-graph? layered diagram?). | Determines FR-6 rendering. | Left-to-right layered flow diagram (stages as nodes, edges as data flow) plus a viability checklist. |
| 4 | Where does the venture to-do list / daily agenda live in the UI? Narrated, not clearly shown. | Needed to build FR-11. | A "To-Do / Agenda" card in the venture workspace and/or a global daily-agenda view; OSA can append tasks to it. |
| 5 | Does "Present" export/download the deck, or only enter full-screen? Not exercised. | Affects export scope (a Non-Goal today). | Enter in-app full-screen presentation only; treat export as future scope. |
| 6 | Are generated documents editable, or read-only review artifacts? Only opened for review. | Affects document-viewer complexity. | Read-only viewer with a "regenerate" action; inline editing is future scope. |
| 7 | Exact values/axes behind the analytics charts (Market Opportunity, Competitive Landscape, Risk, Segments) — labels are small/blurred. | Affects analytics fidelity. | Render from venture-derived data: TAM/SAM/SOM bars, competitor scatter (2 axes), risk bars, segment bars; wire to OSA-produced datasets. |
| 8 | Is there any role beyond "Founder" (collaborators, investor viewers)? None shown. | Affects auth/permission model. | Single-user "Founder" role; no sharing/permissions in v1. |
| 9 | What triggers auto-generation of documents — venture instantiation only, or also on demand? | Affects generation orchestration. | Auto-generate the full asset set on venture instantiation; allow per-document regeneration on demand. |
| 10 | Meaning of the OSA quick actions "Analyze" and "Watch" (only "Package" is clearly tied to deck generation). | Affects OSA panel actions. | "Analyze" runs a fresh strategic analysis; "Watch" sets up ongoing monitoring/alerts; both post structured OSA responses. |
| 11 | What is "MediDTX / MDTX flagship project" vs. "BaseLayer" — are these seeded demo data or product concepts? | Affects seed/demo data. | Treat all dashboard projects as seed/demo data; only BaseLayer→SoilSense Pro is the demonstrated golden path. |
| 12 | Persistence/backing of OSA "memory" across sessions. | Affects session model. | Per-venture persistent conversation memory keyed to the venture; a "Sessions" switcher lists prior threads. |
