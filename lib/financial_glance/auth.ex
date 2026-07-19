defmodule FinancialGlance.Auth do
  @moduledoc "Password login and hashed API tokens (ADR-0009)."
  import Ecto.Query
  alias FinancialGlance.Repo
  alias FinancialGlance.Accounts.{User, ApiToken}

  @token_bytes 32

  def register_user(attrs) do
    %User{} |> User.registration_changeset(attrs) |> Repo.insert()
  end

  @doc "Verify email+password; on success return {:ok, plaintext_token}."
  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    if User.valid_password?(user, password) do
      {:ok, create_token(user)}
    else
      {:error, :invalid_credentials}
    end
  end

  @doc "Look up the user for a presented plaintext token (by hash)."
  def user_for_token(plaintext) when is_binary(plaintext) do
    hash = hash_token(plaintext)

    query =
      from t in ApiToken,
        where: t.token_hash == ^hash,
        join: u in assoc(t, :user),
        select: u

    Repo.one(query)
  end

  def user_for_token(_), do: nil

  @doc "Revoke a token (logout)."
  def revoke(plaintext) when is_binary(plaintext) do
    hash = hash_token(plaintext)
    {count, _} = Repo.delete_all(from t in ApiToken, where: t.token_hash == ^hash)
    {:ok, count}
  end

  # --- internals ---

  defp create_token(%User{} = user) do
    plaintext = :crypto.strong_rand_bytes(@token_bytes) |> Base.url_encode64(padding: false)

    Repo.insert!(%ApiToken{token_hash: hash_token(plaintext), user_id: user.id})
    plaintext
  end

  defp hash_token(plaintext) do
    :crypto.hash(:sha256, plaintext) |> Base.encode16(case: :lower)
  end
end
