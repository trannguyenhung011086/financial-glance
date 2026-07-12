# ADR-0003: JSON API as the tech-agnostic contract

**Status:** Active

## Context

For clients to be language-independent, the boundary between core and clients must be a neutral contract, not Elixir function calls.

## Decision

The HTTP JSON API is the one public surface. Clients talk to it only. Publish an OpenAPI spec (`open_api_spex`) at `/api/openapi` so any-language clients can generate typed HTTP clients. Monetary fields return raw `amount_minor` + `currency` and a server-derived `amount_display`; clients never format or compute money.

## Consequences

- Any HTTP-capable language can be a client — the tech-agnostic goal is met.
- The spec is self-documenting and enforceable.
- Formatting/logic stays server-side, keeping clients dumb.
