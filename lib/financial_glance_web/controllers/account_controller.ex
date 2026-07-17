defmodule FinancialGlanceWeb.AccountController do
  use FinancialGlanceWeb, :controller
  alias FinancialGlance.{Accounts, ValueSource}
  alias FinancialGlanceWeb.MoneyJSON

  action_fallback FinancialGlanceWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts(conn.assigns.current_user)
    json(conn, %{data: Enum.map(accounts, &account_json/1)})
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(conn.assigns.current_user, id)
    json(conn, %{data: account_json(account)})
  end

  def create(conn, %{"account" => params}) do
    with {:ok, account} <- Accounts.create_account(conn.assigns.current_user, params) do
      conn |> put_status(:created) |> json(%{data: account_json(account)})
    end
  end

  def update(conn, %{"id" => id, "account" => params}) do
    account = Accounts.get_account!(conn.assigns.current_user, id)
    with {:ok, account} <- Accounts.update_account(account, params) do
      json(conn, %{data: account_json(account)})
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(conn.assigns.current_user, id)
    with {:ok, _} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end

  defp account_json(account) do
    %{
      id: account.id,
      platform: account.platform,
      asset_class: account.asset_class,
      currency: account.currency,
      value_source: account.value_source,
      value: MoneyJSON.data(ValueSource.resolve(account))
    }
  end
end
