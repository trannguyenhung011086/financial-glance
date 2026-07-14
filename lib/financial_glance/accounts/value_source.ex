defmodule FinancialGlance.ValueSource do
  @moduledoc """
  Resolves an account's current value as Money. Pluggable per ADR-0008:
  :manual in v1; :price_feed / :connector are additive later.
  """
  alias FinancialGlance.Money
  alias FinancialGlance.Accounts.Account

  @callback resolve(Account.t()) :: Money.t()

  @doc "Resolve an account's value using its configured source."
  @spec resolve(Account.t()) :: Money.t()
  def resolve(%Account{value_source: "manual"} = account) do
    FinancialGlance.ValueSource.Manual.resolve(account)
  end
end
