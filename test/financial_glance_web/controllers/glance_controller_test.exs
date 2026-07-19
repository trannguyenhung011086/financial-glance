defmodule FinancialGlanceWeb.GlanceControllerTest do
  use FinancialGlanceWeb.ConnCase, async: true
  alias FinancialGlance.{Accounts, Auth}

  setup %{conn: conn} do
    email = "g#{System.unique_integer([:positive])}@ex.com"
    {:ok, user} = Auth.register_user(%{"email" => email, "password" => "password123"})
    {:ok, token} = Auth.authenticate(email, "password123")

    {:ok, _} = Accounts.create_account(user, %{
      "platform" => "TCInvest", "asset_class" => "stocks",
      "amount_minor" => 600_00, "currency" => "USD"
    })

    conn = put_req_header(conn, "authorization", "Bearer " <> token)
    {:ok, conn: conn, user: user}
  end

  test "GET /api/glance returns net worth with derived display", %{conn: conn} do
    conn = get(conn, ~p"/api/glance?currency=USD")
    body = json_response(conn, 200)["data"]

    assert body["net_worth"]["amount_minor"] == 600_00
    assert body["net_worth"]["display"] == "600.00 USD"
    assert [%{"asset_class" => "stocks"}] = body["allocation"]
  end

  test "401 without a token", %{conn: _conn} do
    conn = get(build_conn(), ~p"/api/glance")
    assert json_response(conn, 401)
  end
end
