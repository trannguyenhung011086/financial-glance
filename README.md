# Financial Glance

A low-effort financial-health *glance* for busy people — know where you stand and how it's trending, without tracking every transaction.

Most personal-finance apps demand you categorize every transaction. Financial Glance takes the opposite approach: you record what you hold, capture snapshots when you want, and see your net worth, allocation, and trend at a glance.

## What it is

- **Snapshot-based, not transaction-based.** You state current values; the app tracks how they change over time.
- **Manual-first.** Enter your accounts and balances by hand. No bank connections required.
- **Self-hostable and private.** Run it locally or on your own box; your financial data stays yours.
- **Tech-agnostic by design.** An Elixir/Phoenix engine exposes a JSON API; clients (a TUI today, anything over HTTP later) are dumb consumers of that contract.

## What it is NOT

- **Not a transaction tracker.** There is no `Transaction` entity. Values are stated, not derived from a ledger of movements.
- **Not a budgeting or categorization tool.** Out of scope by design.
- **Not an automation-first product.** Auto-connectors are an optional future layer, never mandatory.
- **Not an opaque "health score."** v1 shows honest primitives (net worth, allocation, trend), not a black-box number.

## Architecture at a glance

One codebase (monolith). An Elixir/Phoenix **core** owns all business logic. A **JSON API** is the tech-agnostic contract. **Clients** (the Node.js TUI, and anything else later) live in the same repo and talk to the core *only* over HTTP — they contain zero business logic. This keeps the stack un-locked-in: any language that can make an HTTP request can be a client.

See [`docs/architecture.md`](docs/architecture.md) for the full picture and [`docs/build-guide.md`](docs/build-guide.md) for the comprehensive spec.

## Run

Local development (native Elixir + Dockerized Postgres):

```
make dev      # starts Postgres (Docker), waits for it, boots Phoenix on :4000
make stop     # stops Postgres
```

The TUI points at `http://localhost:4000` by default.

## Documentation

- [`docs/build-guide.md`](docs/build-guide.md) — comprehensive spec (single source of truth)
- [`docs/architecture.md`](docs/architecture.md) — boundaries and diagram
- [`docs/domain-vocabulary.md`](docs/domain-vocabulary.md) — precise domain terms
- [`docs/api-principles.md`](docs/api-principles.md) — API contract conventions
- [`docs/roadmap.md`](docs/roadmap.md) — v1 scope and deferred vision
- [`docs/adr/`](docs/adr/) — Architecture Decision Records (0001–0015)
- [`AGENTS.md`](AGENTS.md) — hard invariants every contributor (human or AI) must follow

## License

MIT — see [`LICENSE`](LICENSE).
