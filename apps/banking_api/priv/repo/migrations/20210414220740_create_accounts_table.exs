defmodule BankingApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user, :string
      add :balance, :bigint

      timestamps()
    end

    create unique_index(:accounts, [:user])
  end
end
