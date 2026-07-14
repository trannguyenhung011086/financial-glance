defmodule FinancialGlance.ValueSource.Manual do
  @moduledoc "The v1 value source: the user-entered amount, as-is."
  @behaviour FinancialGlance.ValueSource

  alias FinancialGlance.Money
  alias FinancialGlance.Accounts.Account

  @impl true
  def resolve(%Account{amount_minor: amount, currency: currency}) do
    Money.new(amount, currency)
  end
end
