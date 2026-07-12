# ADR-0001: Elixir/Phoenix as the engine

**Status:** Active

## Context

Financial Glance needs a backend that both serves a real product and doubles as a production-style Elixir learning/portfolio piece. The domain — periodic snapshots, background valuation, low-cost hosting — maps naturally onto the BEAM's strengths (OTP, supervision, cheap concurrency). Laravel/PHP was the prior stack and remains the maintainer's day-job stack.

## Decision

Build the engine in Elixir/Phoenix. Treat the product's shape (snapshot generation, scheduled workers, resilient single-node operation) as genuine reasons to choose the BEAM, not just learning motivation.

## Consequences

- The domain's background/scheduled work becomes first-class (GenServers, supervision) rather than bolted-on queues/cron.
- Lower operational footprint and hosting cost for a solo-maintained OSS app.
- Thinner ecosystem than PHP for some integrations (auth scaffolding, connectors) — accepted as more learning, mitigated by keeping those layers optional/later.
