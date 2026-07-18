# Fixture vertical slice

## Routes

- `/` — Follow home: one active Follow or a useful empty state.
- `/search` — Flight-number search and deterministic results.
- `/flights/:id` — Cached-first flight detail.

## Direction

Use a restrained, high-contrast product register: true-white working surface, near-black information hierarchy, and signal-rose only for primary actions and selection. Operational conditions use their own semantic colors and always include text. Use one platform system type family with tabular figures for times. Lists and dividers carry most grouping; panels are reserved for the primary current-flight state.

## Required states

- Home: empty and one active Follow.
- Search: untouched, loading skeleton, results, no match, and recoverable error.
- Detail: accepted cached state, stale/offline indicator, phase plus independent disruptions, codeshare alias, timeline, partial terminal/gate data, and unfollow.
- Anonymous Follow limit: preserve the current Follow and explain that an account is required before replacing it.

## Accessibility

Every status and freshness cue has text. Search announces result count and errors. Route codes have expanded semantic labels. Touch targets follow the platform minimums. Large text may reflow times vertically rather than truncate critical values. Motion is limited to short state transitions and is removed when the OS requests reduced motion.

## Prototype identity

`Cirrava` is an internal codename. The generated bundle identifiers are prototype-only and must not be registered as permanent store identities.
