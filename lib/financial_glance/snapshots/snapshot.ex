defmodule FinancialGlance.Snapshots.Snapshot do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "snapshots" do
    field :captured_at, :utc_datetime
    field :total_minor, :integer
    field :currency, :string
    field :payload, :map, default: %{}
    belongs_to :user, FinancialGlance.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc "Snapshots are append-only: there is only a create changeset."
  def create_changeset(snapshot, attrs) do
    snapshot
    |> cast(attrs, [:captured_at, :total_minor, :currency, :payload, :user_id])
    |> validate_required([:captured_at, :total_minor, :currency, :user_id])
    |> assoc_constraint(:user)
  end
end
