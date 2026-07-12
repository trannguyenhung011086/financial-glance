# ADR-0014: Allocation targets optional; never fabricated or randomized

**Status:** Deferred

## Context

The rule-based evaluator (ADR-0013) compares current allocation to targets. New users have no targets, and inventing them would produce misleading advice.

## Decision

`AssetClassTarget` is optional per user. The evaluator degrades gracefully: with no targets it shows net worth, trend, allocation, and concentration; with targets it adds drift and rebalancing insights. Offer preset strategies (Balanced / Growth / Conservative) as a starting point users can customize. Never fabricate or randomize targets.

## Consequences

- No blank-slate failure; descriptive insights work without targets.
- Low friction to unlock rebalancing (pick a preset), with full personalization as the end state.
- Advice is only given when the user has stated what they're aiming for.
