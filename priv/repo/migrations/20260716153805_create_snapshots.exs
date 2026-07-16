defmodule FinancialGlance.Repo.Migrations.CreateSnapshots do
  use Ecto.Migration

  def change do
    create table(:snapshots, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :captured_at, :utc_datetime, null: false
      add :total_minor, :bigint, null: false
      add :currency, :string, null: false
      add :payload, :map, null: false, default: "{}"
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:snapshots, [:user_id, :captured_at])
  end
end
