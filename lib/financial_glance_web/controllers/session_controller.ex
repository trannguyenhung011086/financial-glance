defmodule FinancialGlanceWeb.SessionController do
  use FinancialGlanceWeb, :controller
  alias FinancialGlance.Auth

  # POST /api/login  — public
  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate(email, password) do
      {:ok, token} ->
        conn |> put_status(:created) |> json(%{data: %{token: token}})

      {:error, :invalid_credentials} ->
        conn |> put_status(:unauthorized) |> json(%{error: "invalid credentials"})
    end
  end

  # POST /api/logout — authenticated
  def delete(conn, _params) do
    Auth.revoke(conn.assigns.current_token)
    send_resp(conn, :no_content, "")
  end
end
