# ADR-0012: captured_at as the FX reconstruction hook; FX read-time / lazy

**Status:** Deferred

## Context

Currency switching is genuinely hard *if* made mandatory infrastructure, but few users switch currency. Re-denominating stored snapshots would corrupt the trend, which is the whole point of the app.

## Decision

No FX code in v1 (`:identity` source). FX, when it exists, is a **read-time, read-only, lazy, cached** concern — never in the write path. Because every snapshot stores `captured_at`, a future `HistoricalRateSource(from, to, captured_at)` can reconstruct the trend in a new currency at each period's own historical rate, fetching on first view and caching the rate back into the snapshot's `exchange_rates` map. Stored snapshots are never re-denominated.

## Consequences

- v1 ships with zero FX complexity; the timestamp is the only thing needed to add it later.
- The common case (one currency) never pays the FX cost.
- Historical accuracy preserved: each period converts at its own rate.
