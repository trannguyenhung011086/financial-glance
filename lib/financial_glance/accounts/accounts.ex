defmodule FinancialGlance.Accounts do
  @moduledoc "The Accounts context: users and their financial accounts."
  import Ecto.Query, warn: false
  alias FinancialGlance.Repo
  alias FinancialGlance.Accounts.{User, Account}

  # --- Users (minimal; auth arrives in #7) ---

  def create_user(attrs) do
    %User{} |> User.registration_changeset(attrs) |> Repo.insert()
  end

  def get_user!(id), do: Repo.get!(User, id)

  # --- Accounts (always scoped to a user) ---

  def list_accounts(%User{id: user_id}) do
    Account |> where(user_id: ^user_id) |> Repo.all()
  end

  def get_account!(%User{id: user_id}, id) do
    Account |> where(user_id: ^user_id) |> Repo.get!(id)
  end

  def create_account(%User{id: user_id}, attrs) do
    %Account{}
    |> Account.changeset(Map.put(attrs, "user_id", user_id))
    |> Repo.insert()
  end

  def update_account(%Account{} = account, attrs) do
    account |> Account.changeset(attrs) |> Repo.update()
  end

  def delete_account(%Account{} = account), do: Repo.delete(account)
end
