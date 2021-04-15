defmodule BankingApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table :accounts do
      add :user, :string
      add :balance, :integer

      timestamps()
    end
    create constraint(:accounts, :valid_balance, check: "balance >= 0")
  end
end
