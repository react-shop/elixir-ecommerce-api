defmodule ApiEcommerce.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string
    field :role, RoleEnum, default: :member
    field :status, StatusEnum, default: :active
    field :recovery_token, :string
    field :recovery_token_created_at, :naive_datetime
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :status, :role, :password, :password_confirmation])
    |> validate_required([:email, :status, :role, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password) # Check that password === password_confirmation
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(Bcrypt.add_hash(password))
    |> change(%{password_confirmation: nil})
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
