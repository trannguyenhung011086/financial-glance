defmodule FinancialGlanceWeb.Plugs.CurrentUser do
  @moduledoc "Authenticates via `Authorization: Bearer <token>` (ADR-0009)."
  import Plug.Conn
  alias FinancialGlance.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         user when not is_nil(user) <- Auth.user_for_token(token) do
      conn
      |> assign(:current_user, user)
      |> assign(:current_token, token)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "unauthorized"})
        |> halt()
    end
  end
end
