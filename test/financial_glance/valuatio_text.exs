defmodule FinancialGlance.ValuationTest do
  use ExUnit.Case, async: true

  alias FinancialGlance.Valuation
  alias FinancialGlance.Accounts.Account

  defp account(asset_class, amount_minor, currency \\ "USD") do
    %Account{
      asset_class: asset_class,
      amount_minor: amount_minor,
      currency: currency,
      value_source: "manual"
    }
  end

  describe "summarize/2" do
    test "empty list yields zero net worth and no allocation" do
      result = Valuation.summarize([], "USD")
      assert result.net_worth.amount_minor == 0
      assert result.allocation == []
    end

    test "sums net worth across accounts" do
      accounts = [account("stocks", 600_00), account("cash", 400_00)]
      result = Valuation.summarize(accounts, "USD")
      assert result.net_worth.amount_minor == 1_000_00
    end

    test "computes allocation percentage per asset class" do
      accounts = [account("stocks", 600_00), account("cash", 400_00)]
      result = Valuation.summarize(accounts, "USD")

      by_class = Map.new(result.allocation, &{&1.asset_class, &1.percentage})
      assert by_class["stocks"] == 60.0
      assert by_class["cash"] == 40.0
    end

    test "groups multiple accounts of the same class" do
      accounts = [account("gold", 100_00), account("gold", 200_00), account("cash", 700_00)]
      result = Valuation.summarize(accounts, "USD")

      gold = Enum.find(result.allocation, &(&1.asset_class == "gold"))
      assert gold.value.amount_minor == 300_00
      assert gold.percentage == 30.0
    end

    test "allocation is sorted by value descending" do
      accounts = [account("cash", 100_00), account("stocks", 900_00)]
      result = Valuation.summarize(accounts, "USD")
      assert Enum.map(result.allocation, & &1.asset_class) == ["stocks", "cash"]
    end

    test "handles VND (zero-decimal currency)" do
      accounts = [account("stocks", 654_408_575, "VND")]
      result = Valuation.summarize(accounts, "VND")
      assert result.net_worth.amount_minor == 654_408_575
      assert hd(result.allocation).percentage == 100.0
    end
  end
end
