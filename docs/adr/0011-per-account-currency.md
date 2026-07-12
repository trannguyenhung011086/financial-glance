# ADR-0011: Per-account currency stored from day one; single base currency in v1

**Status:** Active

## Context

v1 is single-currency per instance (default USD for OSS; the maintainer's instance runs VND). But a real portfolio may eventually hold accounts in different currencies, requiring conversion to a base currency to sum net worth.

## Decision

Every account stores its own `currency` from day one, even though v1 enforces a single base currency per instance. Net worth in v1 is a simple sum (all one currency). True multi-currency (summing across currencies) is a later phase, at which point conversion uses the FX seam (ADR-0012).

## Consequences

- Costs nothing now; makes multi-currency additive later, not a migration.
- Instance base currency is configured via `DEFAULT_CURRENCY`.
- Display-currency toggle (VND <-> USD) is a safe read-time feature for v2.
