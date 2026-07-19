defmodule FinancialGlance.Accounts.ApiToken do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "api_tokens" do
    field :token_hash, :string
    belongs_to :user, FinancialGlance.Accounts.User

    timestamps(type: :utc_datetime)
  end
end
