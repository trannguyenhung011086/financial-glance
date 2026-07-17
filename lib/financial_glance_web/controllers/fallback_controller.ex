defmodule FinancialGlanceWeb.FallbackController do
  @moduledoc """
  Translates context {:error, ...} results into JSON error responses.
  Referenced by controllers via `action_fallback`.
  """
  use FinancialGlanceWeb, :controller

  # Changeset validation errors -> 422 with field messages
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: translate_errors(changeset)})
  end

  # Not found -> 404
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "not found"})
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
