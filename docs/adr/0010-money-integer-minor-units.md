# ADR-0010: Money as integer minor units + ISO 4217 currency; display derived

**Status:** Active

## Context

Money must be exact. Floats can't represent it (0.1 + 0.2 != 0.3). Currencies differ in decimal places (USD 2, VND 0, BHD 3).

## Decision

Store money as an integer count of the smallest unit (`amount_minor`) + an ISO 4217 `currency` code. Never floats. All money math goes through a `Money` module. The display string (`amount_display`) is derived at read time by the module and **never stored**.

## Consequences

- Exact arithmetic, no rounding drift.
- Currency's definition dictates decimal places; formatting happens only at display.
- VND (0 minor units) maps 1:1 with the dong value — no cents gymnastics.
- Storing the display string would let it drift — forbidden.
