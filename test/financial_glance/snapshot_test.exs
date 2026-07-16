defmodule FinancialGlance.SnapshotsTest do
  use FinancialGlance.DataCase, async: true

  alias FinancialGlance.{Accounts, Snapshots}

  defp user_with_accounts do
    {:ok, user} = Accounts.create_user(%{"email" => "s#{System.unique_integer([:positive])}@ex.com"})

    {:ok, _} = Accounts.create_account(user, %{
      "platform" => "TCInvest", "asset_class" => "stocks",
      "amount_minor" => 600_00, "currency" => "USD"
    })
    {:ok, _} = Accounts.create_account(user, %{
      "platform" => "Bank", "asset_class" => "cash",
      "amount_minor" => 400_00, "currency" => "USD"
    })

    user
  end

  test "capture/1 appends an immutable snapshot with the right total" do
    user = user_with_accounts()
    {:ok, snap} = Snapshots.capture(user, currency: "USD")

    assert snap.total_minor == 1_000_00
    assert snap.currency == "USD"
    assert [%{"asset_class" => _} | _] = snap.payload["allocation"]
  end

  test "multiple captures append multiple rows (append-only)" do
    user = user_with_accounts()
    {:ok, _} = Snapshots.capture(user, currency: "USD")
    {:ok, _} = Snapshots.capture(user, currency: "USD")

    assert length(Snapshots.list_snapshots(user)) == 2
  end

  test "list_snapshots/1 returns oldest first" do
    user = user_with_accounts()
    t1 = ~U[2026-01-01 00:00:00Z]
    t2 = ~U[2026-02-01 00:00:00Z]
    {:ok, _} = Snapshots.capture(user, currency: "USD", captured_at: t2)
    {:ok, _} = Snapshots.capture(user, currency: "USD", captured_at: t1)

    [first, second] = Snapshots.list_snapshots(user)
    assert DateTime.compare(first.captured_at, second.captured_at) == :lt
  end
end
