# ADR-0009: Token-based auth for CLI clients (local token file v1, keychain later)

**Status:** Active

## Context

A terminal client can't use browser cookies/redirects. The real-product pattern for a CLI/TUI is a long-lived token stored locally (as gh CLI and flyctl do).

## Decision

`POST /login` (email + password) returns a token. The TUI stores it in `~/.config/financial-glance/credentials`. Subsequent requests carry `Authorization: Bearer `. Server-side: tokens stored hashed, validated in an auth plug that assigns `current_user`; `POST /logout` invalidates. v1 uses a plain config file; OS keychain is a future hardening step. Ownership is enforced in context functions (every query scoped by user).

## Consequences

- "Session" = persisted token on disk + server-side validation — no cookies.
- Simple, private, self-contained (no third-party IdP).
- Device-flow / keychain storage deferred as later enhancements.
- Passwords hashed with bcrypt; API tokens are random, stored as SHA-256 hashes in api_tokens, presented as Bearer tokens; logout deletes the token row.
