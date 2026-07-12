# ADR-0013: Evaluation layered — rule-based floor, AI optional augmentation

**Status:** Deferred

## Context

The product will eventually offer recommendations (allocation drift, rebalancing). AI could enrich these, but a finance app must keep numbers trustworthy and must not force a dependency on an LLM.

## Decision

Evaluation is layered behind an `Evaluator` behaviour producing `Insight` structs. `:rule_based` (v2) is deterministic: allocation drift vs. target, rebalancing hints, concentration risk, trend, cash buffer. `:ai` (v3) is optional and config-gated; it narrates the *same computed primitives* and never performs the underlying math. Three principles: the rule-based layer is never removed; AI operates on computed numbers, not raw data; AI is opt-in so privacy/offline self-hosters stay fully rule-based.

## Consequences

- Useful, trustworthy recommendations without AI.
- AI is additive, optional, and grounded — never invents numbers.
- Framing stays "observations and rebalancing math," not "financial advice."
