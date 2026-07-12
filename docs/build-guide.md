# Financial Glance — Build Guide

The comprehensive spec and single source of truth. The ADRs in `docs/adr/` capture individual decisions; this guide is the narrative that ties them together. When a decision changes, update the relevant ADR in the same PR; refresh this guide periodically as the readable overview.

## I. Product thesis & non-goals

**Thesis:** a low-effort financial-health *glance* for busy people — know where you stand and how it's trending, without tracking every transaction. Most finance apps are transaction-tracking maximalists; the wedge here is the opposite: snapshot-based, current-state over history, low effort.

**Dual goal:** production-style Elixir (portfolio) + a real, self-useful OSS app. Depth-first, no time pressure (a stable PHP day job covers income), but ship a small real v1 you actually use.

**Non-goals (deliberate — see ADR-0015):** no transactions, no categorization/budgeting, no forced automation, no opaque health score.

## II. v1 scope — capture + glance

- Elixir/Phoenix engine + JSON API (the contract).
- Node.js TUI as the v1 client — the app you actually use.
- Manual holdings input, source-agnostic via the `ValueSource` behaviour (`:manual` only in v1).
- The glance view: net worth, allocation % by asset class, trend across snapshots.
- gh-CLI-style auth + session: email+password → local token file; server-side token validation + logout.
- Local-first (TUI → `localhost:4000`); self-host via `docker compose up`.

Deferred from v1: allocation targets + rule-based rebalancing (v2), AI narrative (v3), currency switching/FX, auto-connectors.

## III. Domain — grounded in the real spreadsheet

- **Account** is the base unit: `platform`, `asset_class`, `amount_minor`, `currency`, `value_source`, `user_id`. A named position with a current value. Liabilities are accounts with negative value → net worth = assets − liabilities.
- **Holding** is an optional detail on investment accounts (symbol + quantity, e.g. gold 14 chỉ, silver 4 lượng), valued via quantity × unit price.
- **Asset classes:** Stocks, Mutual Funds, Gold, Silver, Cash (extensible).
- **Snapshot** (see ADR-0004): append-only, recompute on capture, arbitrary timestamps. Two capture paths — on-demand (any time) and the `SnapshotWorker` scheduled baseline (monthly by default, configurable). Both append immutable rows with their own `captured_at`.

Spreadsheet → domain mapping: Accounts tab → `Account`; Dashboard (Value/Target%/Current%) → derived `Valuation` (targets = v2); Monthly History → `Snapshot` ledger; Prices (Qty/Current) → `:quantity` value source.

## IV. Money model (ADR-0010, 0011, 0012)

- Integer **minor units** + ISO 4217 currency. Never floats. All math through a `Money` module.
- `amount_display` derived at read time, never stored.
- Per-account `currency` stored from day one (multi-currency-ready); instance has one base currency; default USD for OSS, VND for the maintainer's instance.
- FX (deferred): read-time, lazy, cached; reconstructed from snapshot `captured_at` via a `HistoricalRateSource`. No FX in the write path; never re-denominate stored snapshots.

## V. Architecture (ADR-0002, 0003, 0005)

- Elixir monolith; **JSON API is the tech-agnostic contract** (+ OpenAPI spec); clients are dumb HTTP consumers.
- Client-agnostic core → BFFs/umbrella deferred until justified.
- Deliberately avoid LiveView/in-process calls for clients (they lock the stack to Elixir).

## VI. Local dev, deploy (ADR-0006, 0007)

- Native BEAM for dev + Docker Postgres + `make dev` (compose up → `pg_isready` wait → `mix phx.server`).
- Production: mix-release Dockerfile on Fly.io. Kubernetes deferred (overlaps with what the BEAM already does).

## VII. Deferred vision — seams in place

- **Evaluation (ADR-0013):** `Evaluator` behaviour. `:rule_based` (v2) computes drift, rebalancing, concentration, cash buffer — pure and deterministic. `:ai` (v3) narrates the *same* computed primitives, never does the math, config-gated and optional; the rule-based floor is never removed.
- **Targets (ADR-0014):** optional per user; degrade gracefully without them; offer presets; never fabricate or randomize.
- **Auto-connectors:** additive `ValueSource` implementations.
- **Distribution:** three tiers from one artifact — you/contributors (`make dev`), self-hosters (`docker compose up` + TUI), optional hosted Fly.io later.

## VIII. Docs-first (Phase 0)

Write docs before code so the architecture dictates the code. `README.md`, `AGENTS.md` (hard invariants), `docs/*`, `docs/adr/0001–0015`, `LICENSE`, `CONTRIBUTING.md`. Matters more here because AI agents help build — `AGENTS.md` + ADRs stop an agent from quietly coupling a client to the core.

## IX. How we work

GitHub Issues as a Kanban board (Backlog → Ready → In Progress → In Review → Done), driven progressively off this guide. Each issue = one guide slice = one PR. Branch per issue, Conventional Commits, `Closes #N`. When a decision changes, the ADR update rides along in the same PR. Owner drives all git/mix/Docker; the assistant drafts content/code and reviews diffs shared as URLs.

## X. v1 build order

1. Docs + ADRs (Issue #1) — this phase.
2. Foundation + `make dev` (#2).
3. Account schema + Money module + ValueSource (#3).
4. Valuation: net worth + allocation, pure (#4).
5. Snapshots: append-only capture + SnapshotWorker (#5).
6. JSON API + OpenAPI (#6).
7. Token auth + session (#7).
8. Node.js TUI client (#8).
9. Self-host packaging (#9).

The one rule above all: ship the small v1 and use it. The deferred features are documented with seams in place, so they build later without rewrites.
