# Evidence rules for video-derived product specifications

## Contents

1. Evidence classes
2. Full-video review
3. Transcript handling
4. Screenshot selection
5. Product-state mapping
6. Uncertainty and prototype language
7. Copyright and retention
8. Evidence-notes structure
9. Quality checklist

## 1. Evidence classes

Apply one of these classes to product claims during analysis:

- **Observed:** directly visible in the product UI or explicitly stated in narration. Examples: a concept-filter control is visible; narration says a project can create ventures.
- **Inferred:** necessary to make observed behavior coherent as a production product. Examples: persistent object IDs, background jobs, artifact versioning, tenant-scoped retrieval.
- **Recommended:** a product, safety, or implementation choice not demonstrated directly. Examples: approval diffs, undo, accessibility alternatives, latency targets.

Use observed evidence to reconstruct demonstrated functionality. Use inferred requirements sparingly and explain why they are necessary. Use recommended requirements for production quality, safety, and operability. Do not blur the three classes.

## 2. Full-video review

Review the complete recording at least once. Build a rough timeline before choosing screenshots. Detect:

- product/module transitions;
- navigation and object creation;
- loading or generation states;
- AI request and response boundaries;
- external-editor or export transitions;
- decisions that trigger downstream changes;
- repeated screens that show new state rather than new capability.

Do not infer the product from a thumbnail, transcript, title, description, or contact sheet alone.

## 3. Transcript handling

Prefer creator captions over platform captions and platform captions over machine transcription. Preserve timestamp ranges regardless of source.

For machine transcription:

- seed the model with visible product and domain names when supported;
- compare uncertain words against interface labels;
- compare important numbers against visible metrics;
- keep a short ambiguity note rather than silently correcting uncertain terminology;
- paraphrase the meaning in evidence notes;
- do not call the result an official transcript.

Do not reproduce a full transcript unless the user requests it. A PRD normally needs time-coded product meaning, not a verbatim transcript.

## 4. Screenshot selection

Capture frames that prove a distinct product capability or state transition. Strong candidates include:

- home or portfolio dashboard;
- primary project/workspace;
- discovery, visualization, or filtering;
- selected-item details and comparison;
- AI/coplay request and synthesized response;
- architecture or system diagram;
- persistent object creation;
- analytics, roadmap, or risk state;
- generated intelligence artifacts;
- strategy-driven workflow changes;
- packaging, deck, report, or financial outputs.

Reject frames with:

- splash branding but no product evidence, unless positioning is itself needed;
- video-player controls over important UI;
- motion blur, fades, partial wipes, or zoom transitions;
- interframe corruption or black blocks;
- cropped labels or unreadable content;
- a state already captured more clearly elsewhere.

Use the highest source resolution available. Preserve the original aspect ratio. Number files sequentially in the intended narrative order.

For exact extraction from interframe-compressed video, decode through the requested time rather than returning the nearest prior keyframe. The bundled extractor uses a `select=gte(t,...)` filter for this reason.

## 5. Product-state mapping

For each selected frame, record:

- approximate timestamp;
- descriptive filename;
- visible module and object;
- user action immediately before the state;
- resulting state or output;
- requirement areas the frame supports;
- whether the surface is the core product, a generated export, or an external tool.

Connect states into a lifecycle. Identify what context must persist across the transitions and what downstream objects become stale when an earlier decision changes.

## 6. Uncertainty and prototype language

Use precise language:

- “The demo shows…” for observed UI.
- “The narration positions…” for stated vision.
- “A production implementation requires…” for inferred requirements.
- “This PRD recommends…” for recommended behavior.

Do not claim that a prototype screen is live, integrated, scalable, secure, or production-ready without evidence. Treat sample numbers as UI content unless the narration establishes them as real business data.

If a name, number, or claim cannot be verified, omit it from binding requirements or mark it as uncertain in `EVIDENCE_NOTES.md`.

## 7. Copyright and retention

Use source content for analysis and limited evidentiary screenshots. Avoid redistributing the complete video, audio, or transcript. Do not retain downloaded media, extracted audio, speech models, storyboards, or full transcripts in the final deliverable directory unless the user explicitly asks.

Keep quotes short and necessary. Prefer paraphrased, time-coded synthesis.

## 8. Evidence-notes structure

Create `EVIDENCE_NOTES.md` with:

1. Source metadata: title, creator/channel, duration, URL/path, access date.
2. Method: complete visual review, caption/transcription method, screenshot method.
3. Interpretation policy: Observed, Inferred, Recommended.
4. Ambiguities and limitations.
5. Time-coded vision table with meaning and product implication.
6. Screenshot index with number, timestamp, state, and filename.

Do not duplicate the entire PRD in the evidence notes.

## 9. Quality checklist

Before writing:

- Complete video reviewed.
- Narration source recorded.
- Important terminology reconciled with UI.
- Product-state timeline complete.
- Stable representative frames selected.

Before delivery:

- Every image visually inspected.
- Filenames match image contents.
- No duplicate or corrupt frames.
- Every screenshot referenced in the PRD exists.
- Observed, inferred, and recommended claims are distinguishable.
- No full source media or transcript retained unintentionally.
