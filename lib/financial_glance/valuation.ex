defmodule FinancialGlance.Valuation do
  @moduledoc """
  Pure valuation over a list of accounts: net worth + allocation by asset class.

  No DB, no side effects. Values are resolved via ValueSource (source-agnostic)
  and summed with Money (integer minor units). Percentages are display-only
  floats and never feed back into money math. See ADR-0004, ADR-0010.
  """
  alias FinancialGlance.{Money, ValueSource}
  alias FinancialGlance.Accounts.Account

  @type allocation_entry :: %{
          asset_class: String.t(),
          value: Money.t(),
          percentage: float()
        }

  @type summary :: %{
          net_worth: Money.t(),
          allocation: [allocation_entry()],
          currency: String.t()
        }

  @doc """
  Summarize a list of accounts into net worth + allocation.

  All accounts are assumed to share `currency` (v1 single-currency, ADR-0011).
  Returns net worth as Money, and a per-asset-class allocation list sorted by
  value descending. An empty list yields zero net worth and empty allocation.
  """
  @spec summarize([Account.t()], String.t()) :: summary()
  def summarize(accounts, currency \\ "USD")

  def summarize([], currency) do
    %{net_worth: Money.zero(currency), allocation: [], currency: currency}
  end

  def summarize(accounts, currency) do
    # Resolve each account to Money via its value source (source-agnostic).
    valued =
      Enum.map(accounts, fn account ->
        {account.asset_class, ValueSource.resolve(account)}
      end)

    net_worth =
      valued
      |> Enum.map(fn {_class, money} -> money end)
      |> Money.sum(currency)

    allocation =
      valued
      |> Enum.group_by(fn {class, _money} -> class end)
      |> Enum.map(fn {class, entries} ->
        class_total =
          entries
          |> Enum.map(fn {_class, money} -> money end)
          |> Money.sum(currency)

        %{
          asset_class: class,
          value: class_total,
          percentage: percentage_of(class_total, net_worth)
        }
      end)
      |> Enum.sort_by(& &1.value.amount_minor, :desc)

    %{net_worth: net_worth, allocation: allocation, currency: currency}
  end

  # Percentage of a part relative to a total, as a display float (2 decimals).
  # Zero total => 0.0, never divides by zero.
  defp percentage_of(_part, %Money{amount_minor: 0}), do: 0.0

  defp percentage_of(%Money{amount_minor: part}, %Money{amount_minor: total}) do
    Float.round(part / total * 100, 2)
  end
end
