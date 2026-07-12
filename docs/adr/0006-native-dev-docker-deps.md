# ADR-0006: Native BEAM for dev; Docker for stateful deps + prod packaging

**Status:** Active

## Context

Elixir's local dev loop (REPL, hot reload, ExUnit) is excellent natively but degrades inside Docker on macOS (volume-mount file-watching is slow/flaky). Postgres, however, is easy and clean to run in a container.

## Decision

Run Elixir natively (via asdf) for development. Run Postgres in Docker Compose. Orchestrate with a `Makefile`: `make dev` brings up Postgres, waits with `pg_isready`, then starts Phoenix. For production, package the app as a `mix release` in a slim Docker image.

## Consequences

- Fast, smooth inner loop (REPL, hot reload, editor tooling intact).
- Reproducible, disposable database.
- One `make dev` command; DB host read from env so native-dev and future full-container setups both work.
