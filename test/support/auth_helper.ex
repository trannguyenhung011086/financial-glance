defmodule FinancialGlance.AuthHelpers do
  alias FinancialGlance.Auth

  def register_and_login(email \\ nil) do
    email = email || "u#{System.unique_integer([:positive])}@ex.com"
    {:ok, user} = Auth.register_user(%{"email" => email, "password" => "password123"})
    {:ok, token} = Auth.authenticate(email, "password123")
    {user, token}
  end
end
