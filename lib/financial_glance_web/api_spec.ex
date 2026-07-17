defmodule FinancialGlanceWeb.ApiSpec do
  @moduledoc "OpenAPI spec for the Financial Glance API."
  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  alias FinancialGlanceWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [Server.from_endpoint(Endpoint)],
      info: %Info{title: "Financial Glance API", version: "0.1.0"},
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
