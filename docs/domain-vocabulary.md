# Domain Vocabulary

Precise definitions so terms don't drift. Grounded in the real portfolio spreadsheet that seeded this domain.

## Account

The **base unit**. A named position with a current value and a type. Everything a person's financial health includes is an Account — a bank balance, an investment position, property, or a liability (negative value).

Fields: `platform` (e.g. TCInvest, Home, Ancarat), `asset_class`, `amount_minor`, `currency`, `value_source`, `user_id`.

## Holding

An **optional detail** on investment-type accounts where value derives from quantity × unit price (e.g. gold "14 chỉ", silver "4 lượng"). Most accounts don't need a Holding — they carry a stated value directly.

## Asset Class

A first-class dimension for allocation: **Stocks, Mutual Funds, Gold, Silver, Cash** (extensible). Net worth breaks down by asset class.

## Snapshot

An **append-only** record of financial state at a moment. Captures `captured_at`, the net-worth total, per-account values, and allocation. Never updated or deleted. Two capture paths:

- **On-demand** — captured any time (on update or explicit "snapshot now").
- **Scheduled baseline** — the `SnapshotWorker` captures on a cadence (monthly by default, configurable), guaranteeing a continuous trend.

Both append immutable rows with their own `captured_at`.

## Value Source

A behaviour describing *how* an account's current value is resolved. `:manual` in v1 (user-entered). Later, additive implementations: `:price_feed` (quantity × live price), `:connector` (bank/brokerage balance). The domain never cares where a value came from.

## Money

`amount_minor` (integer, smallest currency unit) + `currency` (ISO 4217). Display strings are **derived** by the `Money` module at read time, never stored.

## Net Worth

Sum of all account values (assets minus liabilities), in the base currency.

## Valuation

The pure computation over accounts: total net worth, allocation % by class, and trend across snapshots. No DB, no side effects.
