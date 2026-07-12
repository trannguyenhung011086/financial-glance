# API Principles

The JSON API is the tech-agnostic contract. Any language that can make an HTTP request can be a client. These conventions are what clients rely on.

## Contract conventions

- **JSON over HTTP.** Requests and responses are JSON.
- **Numbers + derived display.** Monetary fields return both the raw `amount_minor` (integer) + `currency`, and a derived `amount_display` string formatted server-side. Clients render `amount_display`; they never format or compute money themselves.
- **Thin controllers.** Controllers validate input and call context functions. No business logic in the API layer.
- **Ownership scoping.** Every query is scoped to the authenticated user in the context layer, not the controller.

## Auth

- gh-CLI-style token auth. `POST /login` (email + password) returns a token; the client stores it locally (`~/.config/financial-glance/credentials`).
- Requests carry `Authorization: Bearer `. An auth plug validates the token and assigns `current_user`.
- `POST /logout` invalidates the token server-side. Tokens are stored hashed.

## OpenAPI

The API publishes an OpenAPI spec (via `open_api_spex`) at `/api/openapi`, so any-language clients can generate typed HTTP clients from the contract. The spec is the enforceable, self-documenting definition of the boundary.

## v1 endpoints

- `/accounts` — CRUD
- `/glance` — net worth + allocation + trend summary
- `/snapshots` — index + create (create = capture now)

## Error shape

Errors return a consistent JSON envelope (status + message + optional field errors). Keep it stable — clients depend on it.
