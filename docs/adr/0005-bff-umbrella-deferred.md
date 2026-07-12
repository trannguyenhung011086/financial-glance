# ADR-0005: BFFs / umbrella deferred until justified

**Status:** Deferred

## Context

Different clients may eventually want tailored API responses (a backend-for-frontend per client). An umbrella project is the natural home for BFFs. But splitting early adds apps, deploys, and sync overhead before the problem is real.

## Decision

Start with one shared JSON API. Extract per-client BFFs into an umbrella only when client needs genuinely diverge. BFFs, when they exist, contain no business logic — they call the same core contexts and only shape responses.

## Consequences

- v1 stays simple: one app, one API.
- Because the core is already client-agnostic (ADR-0002), a later BFF extraction is a thin additive app, not a rewrite.
- Trigger to revisit: the shared API accumulating client-specific params, or clients over-fetching.
