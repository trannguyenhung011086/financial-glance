defmodule FinancialGlanceWeb.Plugs.CurrentUser do
  @moduledoc """
  TEMPORARY (Issue #6): resolves the acting user from an `x-user-id` header.
  Issue #7 replaces the internals with Bearer-token validation. The assign
  `:current_user` and this plug's interface stay the same — controllers do
  not change.
  """
  import Plug.Conn
  alias FinancialGlance.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    with [user_id] <- get_req_header(conn, "x-user-id"),
         user when not is_nil(user) <- safe_get_user(user_id) do
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "missing or invalid x-user-id (temporary auth)"})
        |> halt()
    end
  end

  defp safe_get_user(id) do
    Accounts.get_user!(id)
  rescue
    Ecto.NoResultsError -> nil
    Ecto.Query.CastError -> nil
  end
end
