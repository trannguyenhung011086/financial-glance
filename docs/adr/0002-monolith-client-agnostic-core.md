# ADR-0002: Monolith, client-agnostic core

**Status:** Active

## Context

The product will have multiple clients over time (TUI now; web, scripts, third-party later), potentially in different languages. We need a structure that keeps business logic coherent while allowing any-language clients.

## Decision

One codebase (monolith). An Elixir/Phoenix core owns all business logic in client-agnostic contexts. Clients live in the same repo but consume the core only over the HTTP JSON API. Start as a single Phoenix app with clean contexts — not an umbrella.

## Consequences

- The core stays pure and reusable; clients cannot couple to Elixir internals.
- Any language can be a client (see ADR-0003).
- Because the core is client-agnostic, extracting an umbrella + BFFs later is cheap (see ADR-0005).
- Deliberately forgoes LiveView/in-process client calls, which would lock the stack to Elixir.
