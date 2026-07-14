defmodule FinancialGlance.MoneyTest do
  use ExUnit.Case, async: true
  alias FinancialGlance.Money

  describe "new/2" do
    test "builds a value" do
      m = Money.new(840000, "USD")
      assert m.amount_minor == 840000
      assert m.currency == "USD"
    end

    test "rejects unknown currency" do
      assert_raise ArgumentError, fn -> Money.new(100, "XYZ") end
    end
  end

  describe "add/2" do
    test "adds same currency" do
      result = Money.add(Money.new(100, "USD"), Money.new(250, "USD"))
      assert result.amount_minor == 350
    end

    test "refuses different currencies" do
      assert_raise ArgumentError, fn ->
        Money.add(Money.new(100, "USD"), Money.new(100, "VND"))
      end
    end
  end

  describe "sum/2" do
    test "sums a list" do
      monies = [Money.new(100, "USD"), Money.new(200, "USD"), Money.new(50, "USD")]
      assert Money.sum(monies, "USD").amount_minor == 350
    end

    test "empty list is zero" do
      assert Money.sum([], "USD").amount_minor == 0
    end
  end

  describe "display/1" do
    test "USD has two decimals and thousands separators" do
      assert Money.display(Money.new(840000, "USD")) == "8,400.00 USD"
    end

    test "VND has no decimals" do
      assert Money.display(Money.new(654408575, "VND")) == "654,408,575 VND"
    end

    test "handles negative" do
      assert Money.display(Money.new(-500, "USD")) == "-5.00 USD"
    end
  end
end
