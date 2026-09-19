# Flight Passport design brief

## Ownership and status

- Product: Cirrava
- Created: 2026-07-20
- Status: Design direction confirmed; ready for high-fidelity reconstruction and user validation
- Scope: Future product work, explicitly outside public v1
- Visual source: Terrella direction in `design/reference/claude-terrella/Flight Companion.dc.html`

The public label is **Flight Passport**. In product and engineering discussion, use **flight-history profile** when clarity matters. This feature is a personal record of flights and must never be described as an identity document, government passport, visa record, or proof of travel.

## Problem and user need

Cirrava helps someone follow a specific upcoming Flight Instance, but the value of a completed flight currently disappears after the short v1 completion window. People also enjoy remembering and sharing the shape of their travel: where they flew, the routes that repeat, and the year those flights formed.

Flight Passport turns a person's confirmed flight history into a calm, visual record that is enjoyable to revisit and safe to share. Sharing is a primary use case, not an afterthought, but the profile remains private until its owner deliberately creates an image or revocable link.

This is a retention and expression feature. It does not replace Cirrava's core job of reliably following a live Flight Instance and must not expand v1 scope.

## Product hypothesis

If Account Holders can see their completed flights form a distinctive, trustworthy visual history and can control exactly what they share, they will perceive lasting value beyond the day of travel and will share Cirrava organically with friends.

This is a working hypothesis. It needs validation with frequent travelers, occasional travelers, people reconstructing older history, and people who track flights primarily for family.

## Guiding principles

1. **Memory, not competition.** Celebrate a personal history without streaks, ranks, leaderboards, or artificial completion scores.
2. **Truth before spectacle.** Derived statistics must have documented definitions and must not imply precision the underlying flight history cannot support.
3. **Private until shared.** No public profile, discoverability, or automatic sharing. The owner previews the exact output before creating it.
4. **Geography with an equivalent.** The globe is the signature, but every fact and route remains available as accessible text.
5. **Terrella, extended.** Reuse Cirrava's night sky, real geography, cyan routes, amber emphasis, warm paper, Space Grotesk, and Space Mono without imitating Flighty's Passport.

## Confirmed visual direction

The Claude Design reference already establishes the concept: **the user's year drawn on a globe, with arrival stamps on paper**. The repository export references `Passport-Terrella`, but the component itself and its rendered capture were not exported. This brief is the authoritative reconstruction guide.

The selected direction combines three layers:

- **Route globe:** Real great-circle routes and visited airports form the dominant visual memory.
- **Warm paper record:** A restrained paper strip holds abstract Cirrava arrival marks and human-readable highlights.
- **Flight ledger:** A practical chronological list makes the history inspectable and correctable.

The surface uses the implemented mobile palette in `apps/mobile/lib/design_system/app_colors.dart`: night and dark-blue surfaces, white and muted-blue text, cyan routes, amber emphasis, limited violet variation, and warm paper. Color remains restrained outside the geographic visualization.

### Signature interaction

Changing the year redraws the globe and updates the paper record and summary together. The transition lasts 220 ms, uses a simple cross-fade plus route redraw, and becomes an immediate state change when Reduce Motion is enabled. It communicates that all three areas are views of the same filtered history.

### Layout anatomy

```text
┌─────────────────────────────────┐
│ Flight Passport          •••    │
│ [ All time ]  2026  2025       │
│                                 │
│        ROUTE GLOBE              │
│  real arcs + airport points     │
│                                 │
│ 42 flights · 18 airports        │
├ ~ ~ warm paper edge ~ ~ ~ ~ ~ ┤
│ Your year                       │
│ abstract arrival marks          │
│ most-flown route · time aloft   │
├─────────────────────────────────┤
│ Recent flights        View all  │
│ ORD → HND  ·  Apr 12            │
│ CDG → DXB  ·  Mar 27            │
│                                 │
│ [ Share passport ]              │
└─────────────────────────────────┘
```

The paper treatment may use Cirrava's existing torn-paper component, but it must remain one purposeful material transition rather than becoming a scrapbook motif. Arrival marks use airport code, month, and year with abstract geometry; they must not resemble official immigration seals, visas, national emblems, or government stamps.

## Information model

### Included flights

A Flight Instance contributes to Flight Passport only when the Account Holder identifies themselves as having traveled on it. A Flight Follow alone is insufficient because Cirrava never assumes the follower is the passenger.

History can eventually come from:

1. Completed Flight Follows whose Account Holder confirms they traveled.
2. Imported historical flight entries matched to canonical Flight Instances.
3. Manually added historical flights when no canonical match exists.

Imported and manual entries retain their provenance. Entries with unresolved dates, airports, or duplicate identity do not contribute to derived statistics until reconciled; the interface explains what is excluded.

### Derived statistics

| Display | Definition |
| --- | --- |
| Flights | Distinct included Flight Instances, after Codeshare Alias deduplication. |
| Airports | Distinct origin and destination airports in included history. |
| Countries | Distinct airport countries represented in included history. Copy must not claim the user entered or visited the country. |
| Time aloft | Sum of actual airborne durations when known; scheduled duration is never silently substituted. |
| Distance | Sum of documented route distance using one consistent method. Show an approximation label when required. |
| Most-flown route | Most frequent directional origin-destination pair; ties use most recent occurrence, then alphabetical airport code. |
| Airlines and aircraft | Optional details only when provider licensing and data completeness allow them. No protected logos or liveries. |

Replacement Flights remain distinct Flight Instances. A cancelled original does not count as flown; the linked Replacement Flight counts only if the Account Holder confirms they traveled on it.

## Primary journey

```text
Account Holder opens Passport
        ↓
Views all-time globe and summary
        ↓
Filters by year or opens flight ledger
        ↓
Selects Share passport
        ↓
Chooses image or private link
        ↓
Chooses period and visible fields
        ↓
Previews exact recipient output
        ↓
Creates share → system share sheet
        ↓
Can review and revoke active links
```

The user's main action is to understand their personal flight pattern. Sharing is prominent but secondary to the Passport itself.

## Screen specifications

### FP-01 — Passport overview

**Intent:** Give the Account Holder an emotionally satisfying overview that remains precise enough to trust.

**Entry:** Passport destination in authenticated primary navigation, an annual recap deep link, or a completed-flight prompt. The feature does not appear for Anonymous Users because durable history and sharing require an account.

**Content order:**

1. Title and overflow menu.
2. Horizontally scrollable year control with `All time` first.
3. Route globe using real geography and great-circle arcs.
4. Text summary: flights, airports, countries, and one optional secondary statistic.
5. Warm paper record with two or three highlights and abstract arrival marks.
6. Three most recent included flights.
7. `Share passport` primary action.

**Behavior:**

- Render the last accepted local Passport snapshot immediately.
- Show `Updated [relative time]` when data is stale or an import is still reconciling.
- Tapping the globe opens an accessible route list, not a telemetry or live-radar surface.
- Tapping a statistic opens the filtered ledger when a useful drill-down exists.
- Tapping a recent flight opens its read-only historical detail.
- Changing year preserves scroll position near the top and updates all dependent content atomically.

**Copy:**

- Title: `Flight Passport`
- All-time filter: `All time`
- Section title: `Your year` or `Your flying story` for all time
- History action: `View all flights`
- Share action: `Share passport`
- Stale data: `Updated [time]. Connect to refresh your history.`

### FP-02 — Flight ledger

**Intent:** Make the visual story auditable and give people a path to correct incomplete history.

**Content:** Search, year filter, sort control, and chronological flight rows. Each row shows local departure date, operating flight number when known, route, and a provenance indicator only when attention is needed.

**Behavior:**

- Default sort is most recent departure first.
- Codeshare Aliases never create duplicate rows.
- `Needs review` records group at the top only when they affect visible totals; otherwise they remain in chronological position.
- A user may exclude a record from Passport without deleting its underlying history.
- Corrections are reversible and re-run derived totals after confirmation.

**States:** Loading uses row skeletons; offline uses cached rows; an import in progress shows completed and remaining counts without blocking existing history.

### FP-03 — Empty and first-history states

**Intent:** Explain the value without using artificial incompleteness or pressuring users to surrender inbox or calendar access.

**Primary empty copy:**

- Headline: `Your routes will gather here`
- Body: `Flights you confirm as traveled become part of your private Flight Passport.`
- Primary action: `Add a past flight`
- Secondary action: `Track an upcoming flight`

When historical import exists, offer `Import flight history` as an equal, explicit choice. Explain the source, access, and revocation before requesting any permission.

### FP-04 — Share setup

**Intent:** Let the owner choose an output without exposing more information than expected.

Use a full screen rather than a modal because privacy choices, format, and preview need room and must survive interruption.

**Format choices:**

- `Share image` — exports a static social card through the operating-system share sheet.
- `Private link` — creates a restricted, revocable recipient view that works without installing Cirrava.

**Controls:**

- Period: selected year or all time.
- Image ratio: square post or vertical story.
- Include display name: off by default.
- Include route map: on by default.
- Include summary totals: on by default.
- Include airport codes: on by default.
- Include exact dates: off by default.
- Include individual flight numbers: off by default.
- Private-link expiry: 7 days by default, with 24 hours and 30 days available.

Booking references, confirmation codes, ticket numbers, loyalty identifiers, seats, user notes, follower relationships, and precise user location are never eligible for Passport sharing.

**Actions:** `Preview share` and `Cancel`. Leaving the flow preserves choices locally for the current draft but creates no share.

### FP-05 — Share preview

**Intent:** Show exactly what another person will receive before anything leaves Cirrava.

The preview uses the real generated image or the exact restricted link projection. It is not an approximate mock. A persistent summary states the selected period, visible fields, and link expiry.

**Actions:**

- Primary: `Create image` or `Create private link`
- Secondary: `Edit sharing choices`

After creation, open the platform share sheet. Cancelling the platform sheet does not invalidate a created link; the completion screen provides `Copy link` and `Revoke link`.

### FP-06 — Recipient view

**Intent:** Let a friend enjoy the shared story without an account, app installation, tracking scripts, or access to the owner's wider profile.

The responsive web view contains only the restricted snapshot selected by the owner. It shows the route visualization, chosen totals, an optional display name, creation time, and expiry. It does not expose a route back to unshared flights.

**Expired or revoked copy:**

- Headline: `This Flight Passport is no longer available`
- Body: `The person who shared it may have removed the link or its sharing period may have ended.`

The page may offer `Explore Cirrava` after the shared content, but the content remains fully viewable without installation or signup while the link is valid.

### FP-07 — Active shares

**Intent:** Make sharing reversible.

List active private links by preview, period, creation time, and expiry. Each supports `Copy link`, `Change expiry`, and `Revoke`. Revocation requires confirmation because it affects recipients, but no password re-entry unless risk policy later requires it.

## Share-image composition

The static image is a composed artifact, not a screenshot of the app chrome.

- **Vertical story:** 9:16, route globe in the upper two-thirds, paper record across the lower third, small Cirrava attribution.
- **Square post:** 1:1, route globe left or upper half, concise summary and one paper highlight in the remaining space.
- No operating-system chrome, menu controls, scrollbars, or share buttons.
- No airline logos, liveries, government marks, leaderboards, or promotional watermark larger than the smallest summary label.
- The exported image includes a text summary sufficient to understand the statistics when route color cannot be perceived.

## State inventory

| State | Required behavior |
| --- | --- |
| No history | Teach how flights enter Passport and offer manual addition or future tracking. |
| One flight | Center one route and emphasize the memory; do not show meaningless rankings. |
| Large history | Aggregate globe arcs by frequency and progressively render detail; ledger remains searchable. |
| Import running | Keep accepted history usable and show reconciliation progress. |
| Import conflict | Explain the conflicting fields and let the user choose or exclude the record. |
| Duplicate Codeshare Alias | Resolve to one canonical Flight Instance without user-visible duplication. |
| Cancelled plus replacement | Exclude cancelled original from flown totals and preserve the linked history. |
| Missing duration or distance | Omit the affected aggregate or label it as partial; never substitute silently. |
| Offline | Render the cached Passport and ledger; disable creation of new shares with a direct explanation. |
| Share-generation failure | Preserve all choices and offer retry; no duplicate link creation. |
| Expired or revoked link | Return the dedicated unavailable state without revealing whether the owner still has an account. |

## Accessibility requirements

- Meet the same WCAG 2.2 Level AA baseline as the core app.
- Provide a text route list and summary for every globe state.
- Do not encode route frequency, provenance, or selected year by color alone.
- Make the year selector, globe alternative, flight rows, and sharing controls usable with VoiceOver and TalkBack.
- Preserve critical content at maximum supported text scaling; the globe may reduce height before text truncates.
- Use at least 44-point iOS and 48-dp Android action targets.
- Announce filter changes once with the updated summary, not every redrawn route.
- Respect Reduce Motion for year transitions and share-preview generation.
- Exported images need generated alt text alongside the image in Cirrava's own share preview; external platforms may not preserve it.

## Ethical and privacy review

Reviewed against Intent's catalogs for artificial incompleteness, streak manipulation, opaque sharing, privacy defaults, and permission harassment.

- No streaks, badges, ranks, social comparison, or profile-completion score.
- No public profile or searchable Passport.
- No preselected display name, exact dates, or flight numbers in shared output.
- No automatic posting or contact upload.
- No inbox, calendar, or photo permission is requested merely by opening Passport.
- Share links are restricted projections, revocable, and expiring by default.
- Users can exclude a flight without deleting the underlying record.

The design uses no deceptive, coercive, or engagement-maximizing pattern.

## Technical and policy dependencies

Before implementation approval:

1. Confirm provider licensing permits durable flight-history storage, historical import, derivative statistics, and generated share images.
2. Confirm public recipient share views are permitted and whether provider attribution is required.
3. Define a durable account history model separate from the short v1 Completed Flight Follow window.
4. Define how an Account Holder confirms they personally traveled on a Flight Instance.
5. Add restricted Passport projections to the existing ShareLink architecture.
6. Define deterministic aggregation, duplicate resolution, manual-record provenance, and recomputation jobs.
7. Decide whether the globe uses a bundled geographic dataset so the cached overview remains useful offline.
8. Create a separate architecture decision before treating imported or manual flights as canonical Flight Instances.

## Validation plan

Test the prototype with at least four behavioral groups: frequent travelers with large histories, occasional travelers with fewer than five flights, people importing history from another tool, and people uncomfortable sharing travel details.

Validate that participants can:

1. Explain what Flights, Airports, and Countries mean.
2. Find the source of an unexpected total.
3. Exclude or correct a flight without fear of deleting it.
4. Create a social image with their intended period.
5. Predict exactly what a private-link recipient can see.
6. Revoke a link successfully.

Working success signals:

- At least 80% complete the image-sharing flow without assistance in moderated testing.
- Every participant can identify whether exact dates and their name will be shared before creation.
- At least 80% can locate and revoke an active link within 30 seconds.
- No participant interprets the feature as an official passport, proof of border entry, or public profile.

Counter-signals include increased account deletion concerns, unexpected exposure reports, incorrect totals that cannot be traced, or users adding false flights merely to improve their Passport.

## Implementation sequence

1. **Foundation:** Durable traveled-flight history, deterministic aggregates, cached Passport snapshot, overview, and ledger.
2. **Shareable core:** Static square and vertical images with preview-first privacy controls.
3. **Private sharing:** Restricted expiring links, recipient web view, active-share management, and revocation.
4. **History reconstruction:** Imports, reconciliation, manual records, and provenance-aware correction.
5. **Later enrichment:** Annual recap, additional statistics, and platform-specific delight only after truth and sharing are trusted.

## Deliberately excluded

- Government passport or visa storage.
- Airline loyalty accounts and mileage balances.
- Public profiles, follower counts, likes, comments, or social feeds.
- Competitive rankings, streaks, achievement badges, or collectible scarcity.
- Live aircraft telemetry inside Passport.
- Automatically claiming a Flight Follow was personally traveled.
- Sharing booking or passenger information.
