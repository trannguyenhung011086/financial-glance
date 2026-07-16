defmodule FinancialGlance.Snapshots.SnapshotWorker do
  @moduledoc """
  Scheduled baseline capture. Wakes on an interval (monthly by default,
  configurable) and appends a snapshot for every user. On-demand captures
  happen separately via Snapshots.capture/1; this only guarantees continuity.
  """
  use GenServer
  require Logger

  alias FinancialGlance.{Repo, Snapshots}
  alias FinancialGlance.Accounts.User

  # 30 days in milliseconds; override via config for testing/other cadences.
  @default_interval_ms 30 * 24 * 60 * 60 * 1000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    interval = Keyword.get(opts, :interval_ms, configured_interval())
    schedule_tick(interval)
    {:ok, %{interval_ms: interval}}
  end

  @impl true
  def handle_info(:tick, %{interval_ms: interval} = state) do
    capture_all_users()
    schedule_tick(interval)
    {:noreply, state}
  end

  # --- internals ---

  # Stream users in DB-cursor batches so memory stays bounded regardless of
  # user count (Repo.stream requires a transaction). Sequential capture is fine
  # for v1's scale (self-hosted, ~1 user per instance).
  #
  # Scaling ladder if a single instance ever serves many users:
  #   1. Repo.stream (here)                         — bounded memory
  #   2. Task.async_stream(max_concurrency: N)      — N <= Repo pool_size
  #   3. Oban cron -> enqueue one job per user      — retries, backoff, dashboard
  # (3) is the production standard at real multi-tenant scale; deferred per ADR-0007.
  defp capture_all_users do
    Repo.transaction(fn ->
      User
      |> Repo.stream(max_rows: 500)
      |> Stream.each(&capture_user/1)
      |> Stream.run()
    end)
  end

  defp capture_user(user) do
    case Snapshots.capture(user) do
      {:ok, _snapshot} -> :ok
      {:error, reason} -> Logger.warning("snapshot capture failed for #{user.id}: #{inspect(reason)}")
    end
  end

  defp schedule_tick(interval_ms) do
    Process.send_after(self(), :tick, interval_ms)
  end

  defp configured_interval do
    Application.get_env(:financial_glance, __MODULE__, [])
    |> Keyword.get(:interval_ms, @default_interval_ms)
  end
end
