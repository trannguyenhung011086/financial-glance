defmodule FinancialGlance.Money do
  @moduledoc """
  Money as integer minor units + ISO 4217 currency code.

  Never floats. The display string is derived at read time and never stored.
  See ADR-0010.
  """

  @enforce_keys [:amount_minor, :currency]
  defstruct [:amount_minor, :currency]

  @type t :: %__MODULE__{amount_minor: integer, currency: String.t()}

  # Minor-unit exponent per currency. Extend as needed.
  @exponents %{
    "USD" => 2,
    "EUR" => 2,
    "GBP" => 2,
    "VND" => 0,
    "JPY" => 0
  }

  @doc "Build a Money value. Raises on unknown currency or non-integer amount."
  @spec new(integer, String.t()) :: t
  def new(amount_minor, currency)
      when is_integer(amount_minor) and is_binary(currency) do
    unless Map.has_key?(@exponents, currency) do
      raise ArgumentError, "unknown currency: #{currency}"
    end

    %__MODULE__{amount_minor: amount_minor, currency: currency}
  end

  @spec add(t(), t()) :: t()
  def add(%__MODULE__{currency: c} = a, %__MODULE__{currency: c} = b) do
    %__MODULE__{amount_minor: a.amount_minor + b.amount_minor, currency: c}
  end

  def add(%__MODULE__{currency: c1}, %__MODULE__{currency: c2}) do
    raise ArgumentError, "currencies must match: #{c1} != #{c2}"
  end

  @doc "Create a zero Money value for a given currency."
  @spec zero(String.t()) :: t()
  def zero(currency) do
    %__MODULE__{amount_minor: 0, currency: currency}
  end

  @doc "Sum a list of Money values, all of the same currency."
  @spec sum([t()], String.t()) :: t()
  def sum(monies, currency) do
    Enum.reduce(monies, zero(currency), &add(&1, &2))
  end

  @doc """
    Derive the display string. Never stored — computed from amount_minor + currency.

        iex> FinancialGlance.Money.display(FinancialGlance.Money.new(840000, "USD"))
        "8,400.00 USD"

        iex> FinancialGlance.Money.display(FinancialGlance.Money.new(654408575, "VND"))
        "654,408,575 VND"
    """
  @spec display(t()) :: String.t()
  def display(%__MODULE__{amount_minor: amount, currency: currency}) do
      exponent = Map.fetch!(@exponents, currency)
      divisor = Integer.pow(10, exponent)
      whole = div(abs(amount), divisor)
      sign = if amount < 0, do: "-", else: ""

      whole_str = whole |> Integer.to_string() |> group_thousands()

      formatted =
        if exponent == 0 do
          whole_str
        else
          frac = rem(abs(amount), divisor)
          frac_str = frac |> Integer.to_string() |> String.pad_leading(exponent, "0")
          "#{whole_str}.#{frac_str}"
        end

      "#{sign}#{formatted} #{currency}"
    end

    defp group_thousands(digits) do
      digits
      |> String.graphemes()
      |> Enum.reverse()
      |> Enum.chunk_every(3)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.reverse()
      |> Enum.map(&Enum.join/1)
      |> Enum.join(",")
    end
end
