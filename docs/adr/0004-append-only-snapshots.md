# ADR-0004: Snapshots as an append-only ledger

**Status:** Active

## Context

The product delivers "trend over time" without tracking transactions. It needs a mechanism to record financial state at points in time and never distort history.

## Decision

Snapshots are an append-only ledger. Each capture writes one immutable row (`captured_at`, total, per-account values, allocation). Snapshots are never updated or deleted. Two capture paths coexist:

- **On-demand:** captured any time (on update or explicit request), recomputing valuation.
- **Scheduled baseline:** the `SnapshotWorker` GenServer captures on a cadence, monthly by default, interval configurable.

Both append immutable rows with their own `captured_at`.

## Consequences

- Trend is an honest time series; history is never rewritten.
- A clean monthly *view* is a read-time rollup over the raw (possibly irregular) series.
- Immutability is the seam that makes future FX reconstruction safe (see ADR-0012).
