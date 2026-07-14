defmodule FinancialGlance.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :platform, :string
      add :asset_class, :string
      add :amount_minor, :bigint, null: false
      add :currency, :string
      add :value_source, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:accounts, [:user_id])
  end
end
