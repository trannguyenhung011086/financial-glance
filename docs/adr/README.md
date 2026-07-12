# Architecture Decision Records

One file per decision. Format: Context -> Decision -> Consequences. Each is marked **Active** or **Deferred**. When a decision changes, update the relevant ADR in the same PR that changes the code — docs never drift.

| ADR | Decision | Status |
|-----|----------|--------|
| [0001](0001-elixir-engine.md) | Elixir/Phoenix as the engine | Active |
| [0002](0002-monolith-client-agnostic-core.md) | Monolith, client-agnostic core | Active |
| [0003](0003-json-api-contract.md) | JSON API as the tech-agnostic contract | Active |
| [0004](0004-append-only-snapshots.md) | Snapshots as an append-only ledger | Active |
| [0005](0005-bff-umbrella-deferred.md) | BFFs/umbrella deferred until justified | Deferred |
| [0006](0006-native-dev-docker-deps.md) | Native BEAM for dev; Docker for deps + prod packaging | Active |
| [0007](0007-flyio-deploy-defer-k8s.md) | Deploy mix release on Fly.io; defer Kubernetes | Active |
| [0008](0008-manual-input-pluggable-value-source.md) | Manual input v1; pluggable value source | Active |
| [0009](0009-token-auth-cli.md) | Token-based auth for CLI clients | Active |
| [0010](0010-money-integer-minor-units.md) | Money as integer minor units + ISO currency | Active |
| [0011](0011-per-account-currency.md) | Per-account currency from day one; single base v1 | Active |
| [0012](0012-captured-at-fx-hook.md) | captured_at as FX hook; FX read-time/lazy | Deferred |
| [0013](0013-layered-evaluation.md) | Layered evaluation: rule-based floor, AI optional | Deferred |
| [0014](0014-optional-targets.md) | Allocation targets optional; never fabricated | Deferred |
| [0015](0015-non-goals.md) | Non-goals: no transactions/budgeting/forced automation | Active |
