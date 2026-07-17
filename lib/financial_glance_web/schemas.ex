defmodule FinancialGlanceWeb.Schemas do
  alias OpenApiSpex.Schema

  defmodule Money do
    require OpenApiSpex
    OpenApiSpex.schema(%{
      title: "Money",
      type: :object,
      properties: %{
        amount_minor: %Schema{type: :integer, description: "Integer minor units", example: 60000},
        currency: %Schema{type: :string, example: "USD"},
        display: %Schema{type: :string, example: "600.00 USD"}
      },
      required: [:amount_minor, :currency, :display]
    })
  end

  defmodule AllocationEntry do
    require OpenApiSpex
    OpenApiSpex.schema(%{
      title: "AllocationEntry",
      type: :object,
      properties: %{
        asset_class: %Schema{type: :string, example: "stocks"},
        value: Money,
        percentage: %Schema{type: :number, format: :float, example: 60.0}
      }
    })
  end

  defmodule GlanceResponse do
    require OpenApiSpex
    OpenApiSpex.schema(%{
      title: "GlanceResponse",
      type: :object,
      properties: %{
        data: %Schema{
          type: :object,
          properties: %{
            net_worth: Money,
            currency: %Schema{type: :string, example: "USD"},
            allocation: %Schema{type: :array, items: AllocationEntry}
          }
        }
      }
    })
  end
end
