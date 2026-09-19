# Future feature opportunities

## Purpose

This register preserves promising product directions without expanding the agreed Cirrava v1. Each item is a hypothesis to validate, not a committed roadmap promise. The ordering reflects strategic fit with Cirrava's core purpose: reliably following a specific Flight Instance from discovery through arrival.

## Opportunity register

### 1. Flight Passport

Turn confirmed traveled-flight history into a private visual profile, flight ledger, and intentionally shareable story.

- **Why it fits:** Gives completed flights lasting personal value and creates an organic sharing loop.
- **Distinctive angle:** Terrella route globe, inspectable flight history, preview-first social images, and revocable private links.
- **Dependency:** Durable traveled-flight history, aggregation definitions, provider licensing, restricted sharing projections, and account identity.
- **Design:** `docs/product/flight-passport-design.md`
- **Validation question:** Do people value an accurate, controllable travel story enough to return and share it without competitive mechanics?

### 2. Role-aware Flight Follows

Let a follower optionally identify their intent: traveling, meeting someone, or keeping an eye on the flight. Adapt information hierarchy and eligible notifications without assuming a Flight Follow belongs to a passenger.

- **Why it fits:** Builds directly on Cirrava's domain distinction between following and traveling.
- **Distinctive angle:** Competitors share flights; Cirrava can reshape the experience around the follower's actual decision.
- **Dependency:** Follow-intent model, notification-policy variants, and clear ability to change or omit the role.
- **Validation question:** Do these roles predict meaningfully different information and notification needs?

### 3. Flight Truth Timeline

Show an inspectable history of meaningful changes: what changed, when Cirrava accepted it, and how fresh the current state is. Surface unresolved provider disagreement only when it affects a decision.

- **Why it fits:** Cirrava already separates Flight Snapshots, immutable Flight Events, and Data Freshness.
- **Distinctive angle:** Explainability and continuity rather than an opaque latest-value screen.
- **Dependency:** Event API, deterministic normalization, source-conflict policy, and consumer-safe wording.
- **Validation question:** Does the timeline reduce repeated checking and increase trust without exposing provider machinery?

### 4. Replacement Flight chain

Preserve a cancelled Flight Instance and explicitly link a distinct Replacement Flight instead of rewriting history or silently transferring the Flight Follow.

- **Why it fits:** Already established by Cirrava's canonical identity model.
- **Distinctive angle:** Honest operational continuity through cancellation and rebooking.
- **Dependency:** Reliable replacement linkage, explicit follow-transfer action, and notification rules across both histories.
- **Validation question:** Can users understand the relationship and choose the replacement confidently during disruption?

### 5. Since You Last Looked

Summarize only meaningful changes after sleep, poor connectivity, or time away: for example, departed late, arrival estimate changed, and destination gate remained stable.

- **Why it fits:** Converts the Flight Event history into calm catch-up value and reinforces cached state.
- **Distinctive angle:** A deterministic delta summary rather than a conversational guess or notification dump.
- **Dependency:** Last-seen markers, event prioritization, concise templates, and offline-safe rendering.
- **Validation question:** Can a follower regain accurate context in under ten seconds without opening the full timeline?

### 6. Meet Me mode

Create a destination-focused experience for someone collecting a traveler: distinguish landing from gate arrival, estimate when to leave, show the relevant terminal or pickup area, and support lightweight rendezvous signals.

- **Why it fits:** Many Cirrava users follow flights without traveling.
- **Distinctive angle:** Coordinate the person on the ground, not only the person on the aircraft.
- **Dependency:** Role-aware Follows, destination-airport metadata, travel-time integration, privacy-safe coordination, and careful uncertainty language.
- **Validation question:** Which moment actually matters to greeters: landing, gate arrival, terminal exit, or curb readiness?

### 7. Outcome-based alerts

Let followers express the decision they care about: `Tell me when I should leave`, `Tell me when arrival moves by 15 minutes`, or `Only notify me at the gate`.

- **Why it fits:** Extends Notification Decisions from event delivery toward user intent.
- **Distinctive angle:** Notification promises framed around outcomes rather than a long settings checklist.
- **Dependency:** Role-aware Follows, destination context, deterministic eligibility, and clear fallback when Cirrava lacks needed data.
- **Validation question:** Can Cirrava make and keep these promises without encouraging unsafe reliance on predictions?

### 8. Private coordination handoff

Allow a traveler and selected followers to exchange a few bounded signals such as `I have left`, `I am at the terminal`, or `I am at the pickup area` without continuous location sharing.

- **Why it fits:** Completes the journey after operational flight data stops being sufficient.
- **Distinctive angle:** Minimal coordination state rather than chat, social networking, or background surveillance.
- **Dependency:** Share permissions, participant roles, expiration, abuse prevention, and notification controls.
- **Validation question:** Are three or four explicit signals enough to replace repetitive texting?

### 9. Verified mismatch reporting

Let a user report that an airport display or direct observation contradicts Cirrava. Keep it unverified until reviewed or corroborated; never elevate one report to operational truth automatically.

- **Why it fits:** Gives users a recovery path when provider data is late or wrong.
- **Distinctive angle:** Transparent correction loop with strict trust boundaries.
- **Dependency:** Moderation workflow, evidence policy, audit trail, provider feedback channel, and abuse controls.
- **Validation question:** Is report volume and quality sufficient to improve reliability without creating a misleading crowdsourced feed?

## Recommended sequencing

### Near the core

- Flight Truth Timeline
- Replacement Flight chain
- Since You Last Looked

These deepen the reliability promise and reuse Cirrava's existing event and identity decisions.

### Next product wedge

- Role-aware Flight Follows
- Meet Me mode
- Outcome-based alerts
- Private coordination handoff

Together these could position Cirrava as the flight-following product designed equally for travelers and the people waiting for them.

### Retention and distribution

- Flight Passport
- Shareable images and private links

This work should begin only after durable history and provider rights are settled, but the experience is designed in advance because its sharing value can influence the history model.

### Operational research

- Verified mismatch reporting

Prototype the internal trust workflow before exposing a user-facing entry point.

## Guardrails across future work

- A Flight Follow never proves that its owner traveled.
- No feature may silently replace, merge, or rewrite distinct Flight Instances.
- Cached state remains useful state and always communicates Data Freshness.
- Sharing is private by default, previewable, revocable, and limited to a restricted projection.
- No booking references, ticket numbers, loyalty identifiers, seats, or precise location enter analytics or public sharing.
- Avoid streaks, leaderboards, fabricated urgency, notification spam, and permission harassment.
- Do not add maps or visual novelty when they obscure the current operational truth.

