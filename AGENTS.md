# AGENTS.md

Rules for anyone — human or AI — writing code in this repository. These are hard constraints, not suggestions. The architecture's value is the boundary; these rules protect it.

## Read these first

Before writing any code, read (in order):

1. `docs/build-guide.md` — the comprehensive spec and single source of truth.
2. This file (`AGENTS.md`) — the hard invariants below.
3. `CONTRIBUTING.md` — the workflow: branch-per-issue, Conventional Commits, PR/issue linking, and how to add a value source.
4. `docs/adr/` — the decision records. Check the index (`docs/adr/README.md`) and read any ADR relevant to the change. ADRs marked **Deferred** describe features intentionally NOT built yet.
5. `docs/domain-vocabulary.md` — precise domain terms; use them exactly.
6. `docs/architecture.md` and `docs/api-principles.md` — the boundary and the API contract.

If a doc and this file ever conflict, `AGENTS.md` invariants win.

## Invariants

1. **All business logic lives in the Elixir core.** Never put logic in controllers, API views, or clients. Controllers are thin and call context functions only.
2. **Clients consume the HTTP JSON API only.** Never call core contexts from a client, and never introduce in-process or LiveView shortcuts for clients — they would lock the stack to Elixir and defeat the tech-agnostic contract.
3. **Money is integer minor units + ISO 4217 currency.** Never floats. All money math goes through the `Money` module. The display string is *derived at read time* and **never stored**.
4. **Snapshots are append-only.** One immutable row per capture. Never update or delete a snapshot.
5. **Preserve per-account `currency` and snapshot `captured_at`.** These are the seams for multi-currency and FX. Do not drop them even though v1 is single-currency and has no FX.
6. **No FX in the write path.** Currency conversion, when it exists, is a read-time / display concern only. Never re-denominate a stored snapshot.
7. **Do not build deferred features ahead of their roadmap phase.** Allocation targets, the evaluator, AI narrative, FX/currency-switching, and auto-connectors are intentionally out of scope until their phase — even if asked for one in passing. Their seams exist; the implementations do not.
8. **Non-goals stay non-goals.** No transactions, no categorization/budgeting, no forced automation, no opaque health score.

## Process

- **When a decision changes, update the relevant ADR in the same PR.** Docs and code must never drift. The ADR is the durable record.
- **PRs reference their issue** (e.g. `Related to #N`). Use `Closes #N` only when merging should auto-close the issue.
- **Never claim a build, test, or command succeeded without evidence.** If you cannot run `mix`, tests, or Docker in your environment, say so — do not assert a green build you did not observe.
- **Never commit secrets.** No `.env`, tokens, or real financial data. Use `.env.example` for config shape.
- For everything else (branching, commit style, PR flow, contribution surfaces), follow `CONTRIBUTING.md`.

## Where things live

- Core domain (contexts, Ecto schemas, OTP workers): the engine. Pure and client-agnostic.
- API layer (controllers, JSON views, auth plug, OpenAPI spec): the contract.
- Clients (`clients/tui/`, etc.): dumb HTTP consumers. No financial computation client-side.
