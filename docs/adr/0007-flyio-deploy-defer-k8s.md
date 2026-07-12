# ADR-0007: Deploy a mix release in Docker on Fly.io; defer Kubernetes

**Status:** Active

## Context

Much of what teams reach to Kubernetes for (process restart, self-healing, in-app concurrency, service messaging) the BEAM/OTP already does within a node. K8s can actively fight the BEAM (aggressive pod churn discards in-memory state; clustering needs libcluster + headless services). A single BEAM node goes a long way.

## Decision

Deploy as a `mix release` in a slim Docker image on Fly.io (first-class BEAM + clustering support). Defer Kubernetes until org standardization or scale genuinely requires it.

## Consequences

- Docker is orthogonal packaging — always fine.
- Fly.io is the sweet spot for Elixir; one or two nodes suffice at small/medium scale.
- If K8s is ever needed: use libcluster and longer grace periods so it doesn't fight the VM.
