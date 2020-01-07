defmodule ApiEcommerce.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string, null: false
      add :status, :tinyint, null: false, default: 0
      add :role, :tinyint, null: false, default: 0
      add :password_hash, :string
      add :recovery_token, :string
      add :recovery_token_created_at, :naive_datetime

      timestamps()
    end

    create index(:users, [:id])
    create index(:users, [:status])
    create index(:users, [:role])
    create unique_index(:users, [:recovery_token])
    create unique_index(:users, [:email])
  end
end
