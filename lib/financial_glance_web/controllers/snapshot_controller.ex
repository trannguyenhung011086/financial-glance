defmodule FinancialGlanceWeb.SnapshotController do
  use FinancialGlanceWeb, :controller
  alias FinancialGlance.Snapshots

  action_fallback FinancialGlanceWeb.FallbackController

  def index(conn, _params) do
    snapshots = Snapshots.list_snapshots(conn.assigns.current_user)
    json(conn, %{data: Enum.map(snapshots, &snapshot_json/1)})
  end

  def create(conn, params) do
    currency = Map.get(params, "currency", "USD")
    # On-demand capture: direct context call (synchronous, returns the row).
    with {:ok, snapshot} <- Snapshots.capture(conn.assigns.current_user, currency: currency) do
      conn |> put_status(:created) |> json(%{data: snapshot_json(snapshot)})
    end
  end

  defp snapshot_json(s) do
    %{
      id: s.id,
      captured_at: s.captured_at,
      total_minor: s.total_minor,
      currency: s.currency,
      payload: s.payload
    }
  end
end
