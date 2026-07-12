# Architecture

## Shape

Financial Glance is a **monolith with a client-agnostic core**. One codebase, three concerns:

```
        +-------------------------------------+
        |   Elixir Monolith (Phoenix app)      |
        |                                       |
        |   Core domain (contexts, Ecto, OTP)  |  <- all business logic
        |              ^                        |
        |              | (in-process calls)     |
        |   JSON API layer (controllers)        |  <- the tech-agnostic contract
        +--------------+------------------------+
                       |  HTTP / JSON
        +--------------+---------------+--------------+
        v              v               v              v
   Node.js TUI    (web later)    (scripts)      (3rd party)
```

## Boundary rules

- **The core owns all logic.** Contexts are pure and client-agnostic. No web or client concerns leak in.
- **The JSON API is the one public surface.** Clients touch only HTTP endpoints, never Elixir internals.
- **Clients are dumb.** They render and call the API. Any business rule in a client is a leaked boundary.

Deliberately avoided for clients: LiveView and in-process calls. They are powerful but lock the stack to Elixir, which defeats the "any-language client" goal.

## Why this shape

- **Un-locked-in clients.** The HTTP/JSON contract means any language can be a client.
- **Cheap future BFFs.** Because the core is client-agnostic, extracting per-client backends-for-frontends into an umbrella later is additive, not a rewrite (see ADR-0005).
- **Low operational footprint.** A single BEAM node does a lot; deploys stay cheap and simple (see ADR-0007).

## Local dev & deploy

- **Dev:** native Elixir (fast REPL, hot reload) + Dockerized Postgres, orchestrated by `make dev`. See ADR-0006.
- **Deploy:** a `mix release` in a slim Docker image on Fly.io. Kubernetes deferred. See ADR-0007.
