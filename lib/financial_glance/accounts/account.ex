defmodule FinancialGlance.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @asset_classes ~w(stocks mutual_funds gold silver cash)
  @value_sources ~w(manual)

  @type t :: %__MODULE__{
    id: binary(),
    platform: String.t(),
    asset_class: String.t(),
    amount_minor: integer(),
    currency: String.t(),
    value_source: String.t(),
    user_id: binary(),
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :platform, :string
    field :asset_class, :string
    field :amount_minor, :integer
    field :currency, :string
    field :value_source, :string, default: "manual"
    belongs_to :user, FinancialGlance.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:platform, :asset_class, :amount_minor, :currency, :value_source, :user_id])
    |> validate_required([:platform, :asset_class, :amount_minor, :currency, :value_source, :user_id])
    |> validate_inclusion(:asset_class, @asset_classes)
    |> validate_inclusion(:value_source, @value_sources)
    |> validate_length(:currency, is: 3)
    |> assoc_constraint(:user)
  end
end
