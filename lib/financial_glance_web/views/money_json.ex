defmodule FinancialGlanceWeb.MoneyJSON do
  @moduledoc "Shapes a Money value for JSON responses (raw + derived display)."
  alias FinancialGlance.Money

  def data(%Money{} = money) do
    %{
      amount_minor: money.amount_minor,
      currency: money.currency,
      display: Money.display(money)
    }
  end
end
