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

## Record shape (added in #5)

- Snapshots are **per-user**. Each row stores `captured_at`, `total_minor` +
  `currency` (integer minor units), and a JSONB `payload` holding the per-asset-class
  allocation (the `Valuation` output). Indexed on `(user_id, captured_at)`.
- One `Snapshots.capture/1` is shared by both paths: the on-demand path and the
  scheduled `SnapshotWorker`. The worker only guarantees continuity; it is not a
  separate mechanism.

## Scaling of scheduled capture (deferred)

- v1 captures users sequentially via `Repo.stream` (bounded memory), which suits
  the self-hosted, ~1-user-per-instance scale.
- Escalation path if a single instance ever serves many users:
  `Task.async_stream` (concurrency <= Repo pool_size) -> Oban cron enqueuing one
  job per user (retries, backoff, observability). Deferred per ADR-0007.
