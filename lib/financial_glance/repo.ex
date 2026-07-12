defmodule FinancialGlance.Repo do
  use Ecto.Repo,
    otp_app: :financial_glance,
    adapter: Ecto.Adapters.Postgres
end
