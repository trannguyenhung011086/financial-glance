defmodule FinancialGlanceWeb.SessionControllerTest do
  use FinancialGlanceWeb.ConnCase, async: true
  alias FinancialGlance.Auth

  test "POST /api/login returns a token for valid credentials", %{conn: conn} do
    {:ok, _user} = Auth.register_user(%{"email" => "a@ex.com", "password" => "password123"})

    conn = post(conn, ~p"/api/login", %{email: "a@ex.com", password: "password123"})
    assert %{"data" => %{"token" => token}} = json_response(conn, 201)
    assert is_binary(token)
  end

  test "POST /api/login rejects bad credentials", %{conn: conn} do
    {:ok, _} = Auth.register_user(%{"email" => "b@ex.com", "password" => "password123"})
    conn = post(conn, ~p"/api/login", %{email: "b@ex.com", password: "wrong"})
    assert json_response(conn, 401)
  end

  test "authenticated request works with Bearer token, 401 without", %{conn: conn} do
    {:ok, _} = Auth.register_user(%{"email" => "c@ex.com", "password" => "password123"})
    {:ok, token} = Auth.authenticate("c@ex.com", "password123")

    ok = conn |> put_req_header("authorization", "Bearer " <> token) |> get(~p"/api/glance")
    assert json_response(ok, 200)

    no = get(build_conn(), ~p"/api/glance")
    assert json_response(no, 401)
  end
end
