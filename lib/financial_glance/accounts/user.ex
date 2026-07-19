defmodule FinancialGlance.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true, redact: true
    has_many :accounts, FinancialGlance.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  @doc "For creating a user with email + password."
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8, max: 72)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %{valid?: true, changes: %{password: pw}} ->
        put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(pw))

      _ ->
        changeset
    end
  end

  @doc "Verify a plaintext password against the stored hash (constant-time)."
  def valid_password?(%__MODULE__{hashed_password: hash}, password)
      when is_binary(hash) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hash)
  end

  def valid_password?(_, _) do
    # Run a dummy check to avoid timing attacks revealing which emails exist.
    Bcrypt.no_user_verify()
    false
  end
end
