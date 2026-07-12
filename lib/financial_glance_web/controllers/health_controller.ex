defmodule FinancialGlanceWeb.HealthController do
  @moduledoc """
    Healthcheck controller
  """

	use FinancialGlanceWeb, :controller

	def index(conn, _params) do
		json(conn, %{status: "ok"})
	end
end
