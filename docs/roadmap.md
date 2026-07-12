# Roadmap

## v1 — Capture + Glance

Ship a small, self-useful app: capture financial state and see it at a glance.

- Accounts (platform + asset class + current value); optional Holding on investment accounts
- Manual input via the `ValueSource` behaviour (`:manual`)
- Net worth, allocation % by asset class, trend across snapshots
- Append-only snapshots: on-demand + scheduled monthly baseline (`SnapshotWorker`)
- Money as integer minor units + ISO currency; display derived, never stored
- Per-account currency stored from day one; single base currency per instance
- gh-CLI-style token auth + session
- Node.js TUI client (same repo), HTTP-only, zero business logic
- Local-first (TUI → localhost:4000); self-host via `docker compose`

**Done when:** you can log in via the TUI, add real holdings, capture snapshots, and see net worth + allocation + trend against a local instance.

## v2 — Targets & rebalancing

- Allocation targets (optional; preset strategies + user-defined). Never fabricated or randomized.
- Rule-based evaluator: allocation drift, rebalancing hints, concentration risk, cash buffer.
- Display-currency toggle (VND ↔ USD) at read time.

## v3 — AI augmentation

- Optional, config-gated AI narrative that operates on the *same computed primitives* — never does the math, never invents numbers. Rule-based layer always remains the floor.

## Later (seams in place)

- Historical FX: read-time, lazy, cached; reconstructed from snapshot `captured_at` via a `HistoricalRateSource`. No FX code in the write path.
- Auto-connectors: additive `ValueSource` implementations (`:price_feed`, `:connector`).
- Umbrella + per-client BFFs: extracted only when client needs diverge (ADR-0005).

Every deferred item has an architectural seam already present in v1, so it lands as an additive change rather than a rewrite.
