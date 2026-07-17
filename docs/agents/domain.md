# Domain docs

Cirrava uses a single-context domain-documentation layout.

## Before exploring

Read these when they exist:

- `CONTEXT.md` at the repository root.
- Relevant architecture decisions under `docs/adr/`.

If these files do not exist, proceed silently. Domain-modeling workflows create them when terminology or decisions are actually resolved.

## Layout

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
└── src/
```

## Vocabulary

Use terminology defined in `CONTEXT.md` consistently in source code, tests, issues, specifications, and documentation.

If a required concept is missing, determine whether the proposed language is unnecessary or whether the domain model has a genuine gap.

## Architecture decisions

Surface any conflict with an existing ADR explicitly. Do not silently override recorded architectural decisions.
