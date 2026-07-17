defmodule FinancialGlanceWeb.GlanceController do
  use FinancialGlanceWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias FinancialGlance.{Accounts, Valuation}
  alias FinancialGlanceWeb.MoneyJSON
  alias OpenApiSpex.Schema

  operation :show,
    summary: "Net worth and allocation (the glance)",
    parameters: [
      currency: [
        in: :query,
        description: "ISO 4217 base currency for the summary",
        type: :string,
        example: "USD",
        required: false
      ]
    ],
    responses: [
      ok: {"Glance summary", "application/json", FinancialGlanceWeb.Schemas.GlanceResponse}
    ]

  def show(conn, params) do
    currency = Map.get(params, "currency", "USD")
    user = conn.assigns.current_user

    summary =
      user
      |> Accounts.list_accounts()
      |> Valuation.summarize(currency)

    json(conn, %{
      data: %{
        net_worth: MoneyJSON.data(summary.net_worth),
        currency: summary.currency,
        allocation:
          Enum.map(summary.allocation, fn e ->
            %{asset_class: e.asset_class, value: MoneyJSON.data(e.value), percentage: e.percentage}
          end)
      }
    })
  end
end
