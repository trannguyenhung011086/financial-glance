defmodule FinancialGlance.Snapshots do
  @moduledoc "Append-only snapshot ledger. Captures net worth + allocation over time."
  import Ecto.Query, warn: false
  alias FinancialGlance.Repo
  alias FinancialGlance.{Accounts, Valuation}
  alias FinancialGlance.Accounts.User
  alias FinancialGlance.Snapshots.Snapshot

  @doc """
  Capture a snapshot for a user: recompute valuation over their current
  accounts and append one immutable row. Used by both the on-demand path
  and the scheduled worker.
  """
  def capture(%User{} = user, opts \\ []) do
    captured_at = Keyword.get(opts, :captured_at, DateTime.utc_now() |> DateTime.truncate(:second))
    currency = Keyword.get(opts, :currency, "USD")

    summary =
      user
      |> Accounts.list_accounts()
      |> Valuation.summarize(currency)

    %Snapshot{}
    |> Snapshot.create_changeset(%{
      "user_id" => user.id,
      "captured_at" => captured_at,
      "total_minor" => summary.net_worth.amount_minor,
      "currency" => summary.currency,
      "payload" => %{"allocation" => encode_allocation(summary.allocation)}
    })
    |> Repo.insert()
  end

  @doc "A user's snapshots, oldest first (for trend)."
  def list_snapshots(%User{id: user_id}) do
    Snapshot
    |> where(user_id: ^user_id)
    |> order_by(asc: :captured_at)
    |> Repo.all()
  end

  # Allocation entries -> plain maps for JSONB storage (Money -> integer minor).
  defp encode_allocation(allocation) do
    Enum.map(allocation, fn entry ->
      %{
        "asset_class" => entry.asset_class,
        "value_minor" => entry.value.amount_minor,
        "percentage" => entry.percentage
      }
    end)
  end
end
