defmodule FinancialGlanceWeb.Router do
  use FinancialGlanceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: FinancialGlanceWeb.ApiSpec
  end

  pipeline :api_auth do
    plug FinancialGlanceWeb.Plugs.CurrentUser
  end

  scope "/api" do
    pipe_through :api
    get "/openapi", OpenApiSpex.Plug.RenderSpec, :show
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api", FinancialGlanceWeb do
    pipe_through :api

    get "/health", HealthController, :index
    post "/login", SessionController, :create
  end

  scope "/api", FinancialGlanceWeb do
    pipe_through [:api, :api_auth]

    post "/logout", SessionController, :delete
    resources "/accounts", AccountController, except: [:new, :edit]
    get "/glance", GlanceController, :show
    get "/snapshots", SnapshotController, :index
    post "/snapshots", SnapshotController, :create
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:financial_glance, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: FinancialGlanceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
