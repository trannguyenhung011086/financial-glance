# ADR-0015: Non-goals — no transactions, no categorization/budgeting, no forced automation

**Status:** Active

## Context

The product's differentiation is a low-effort "glance" at current state. The biggest risk is scope creep turning it into yet another transaction tracker.

## Decision

Enshrine explicit non-goals. v1 and the domain deliberately exclude:

- **Transactions** — no `Transaction` entity; values are stated, not derived from movements.
- **Categorization / budgeting.**
- **Forced automation** — connectors are optional and additive, never required.
- **Opaque health score** — show honest primitives, not a black-box number.

## Consequences

- The thesis is protected against well-meaning PRs that would erode it.
- Reviewers have a written basis to decline out-of-scope features.
- Keeps v1 small and shippable.
