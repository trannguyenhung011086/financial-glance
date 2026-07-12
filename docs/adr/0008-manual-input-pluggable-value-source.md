# ADR-0008: Manual input for v1; value sources are a pluggable behaviour

**Status:** Active

## Context

The product is manual-first (truest to the low-effort, private thesis), but should allow automatic value sources (price feeds, bank connectors) later without a rewrite.

## Decision

Model "how an account gets its current value" as a `ValueSource` behaviour. v1 ships `:manual` (user-entered). Later, additive implementations — `:price_feed` (quantity × live price), `:connector` (bank/brokerage balance) — implement the same behaviour. The domain never cares where a value came from. Which source is active is configuration.

## Consequences

- v1 ships fast, private, transaction-free.
- Auto-connectors are additive and forever optional; self-hosters can stay fully manual.
- Implementing the behaviour is a well-scoped, inviting contribution surface.
