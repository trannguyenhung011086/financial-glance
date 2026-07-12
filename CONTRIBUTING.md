# Contributing

Thanks for your interest in Financial Glance. This project has a strong, deliberate architecture — please read [`AGENTS.md`](AGENTS.md) before writing code. Those invariants are what keep the project coherent.

## Workflow

1. **One issue → one branch → one PR.** Branch names like `phase-0-docs`, `phase-2-domain`.
2. **Conventional Commits.** e.g. `feat(domain): add Account schema`, `docs: add ADR-0006`, `test(valuation): cover allocation`.
3. **PRs reference the issue** (`Related to #N`) and note which ADRs they touch.
4. **If a decision changes, update the relevant ADR in the same PR.** Docs never drift from code.

## The invariants (summary — full list in AGENTS.md)

- Logic lives in the Elixir core; clients are HTTP-only and dumb.
- Money = integer minor units + ISO currency; display derived, never stored; never floats.
- Snapshots are append-only.
- Preserve per-account `currency` and snapshot `captured_at`.
- No FX in the write path. Targets/AI deferred. Non-goals stay non-goals.

## Adding a value source

The cleanest contribution surface: implement the `ValueSource` behaviour (e.g. a price feed). You shouldn't need to touch the domain to add one — that's the point of the abstraction.

## Local setup

```
make dev      # Postgres (Docker) + Phoenix (native) on :4000
make stop
```

Never commit secrets. Use `.env.example` for config shape; keep your real `.env` out of git.
