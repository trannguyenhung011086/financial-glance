defmodule FinancialGlanceWeb.GlanceControllerTest do
  use FinancialGlanceWeb.ConnCase, async: true
  alias FinancialGlance.Accounts

  setup %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{"email" => "g#{System.unique_integer([:positive])}@ex.com"})
    {:ok, _} = Accounts.create_account(user, %{
      "platform" => "TCInvest", "asset_class" => "stocks",
      "amount_minor" => 600_00, "currency" => "USD"
    })
    conn = put_req_header(conn, "x-user-id", user.id)
    {:ok, conn: conn, user: user}
  end

  test "GET /api/glance returns net worth with derived display", %{conn: conn} do
    conn = get(conn, ~p"/api/glance?currency=USD")
    raw = json_response(conn, 200)
    body = raw["data"]

    assert body["net_worth"]["amount_minor"] == 600_00
    assert body["net_worth"]["display"] == "600.00 USD"
    assert [%{"asset_class" => "stocks"}] = body["allocation"]
  end

  test "401 without x-user-id", %{conn: conn} do
    conn = conn |> delete_req_header("x-user-id") |> get(~p"/api/glance")
    assert json_response(conn, 401)
  end
end
