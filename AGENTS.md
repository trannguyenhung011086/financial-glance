# AGENTS.md

Rules for anyone — human or AI — writing code in this repository. These are hard constraints, not suggestions. The architecture's value is the boundary; these rules protect it.

## Invariants

1. **All business logic lives in the Elixir core.** Never put logic in controllers, API views, or clients. Controllers are thin and call context functions only.
2. **Clients consume the HTTP JSON API only.** Never call core contexts from a client, and never introduce in-process or LiveView shortcuts for clients — they would lock the stack to Elixir and defeat the tech-agnostic contract.
3. **Money is integer minor units + ISO 4217 currency.** Never floats. All money math goes through the `Money` module. The display string is *derived at read time* and **never stored**.
4. **Snapshots are append-only.** One immutable row per capture. Never update or delete a snapshot.
5. **Preserve per-account `currency` and snapshot `captured_at`.** These are the seams for multi-currency and FX. Do not drop them even though v1 is single-currency and has no FX.
6. **No FX in the write path.** Currency conversion, when it exists, is a read-time / display concern only. Never re-denominate a stored snapshot.
7. **Targets and AI are deferred.** v1 has no `AssetClassTarget` entity and no evaluator. Do not add them ahead of their roadmap phase.
8. **Non-goals stay non-goals.** No transactions, no categorization/budgeting, no forced automation, no opaque health score.

## Process

- **When a decision changes, update the relevant ADR in the same PR.** Docs and code must never drift. The ADR is the durable record.
- **One issue → one branch → one PR.** PRs reference the issue (`Closes #N`) and note which ADRs they touch.
- **Never commit secrets.** No `.env`, tokens, or real financial data. Use `.env.example` for config shape.

## Where things live

- Core domain (contexts, Ecto schemas, OTP workers): the engine. Pure and client-agnostic.
- API layer (controllers, JSON views, auth plug, OpenAPI spec): the contract.
- Clients (`clients/tui/`, etc.): dumb HTTP consumers. No financial computation client-side.
