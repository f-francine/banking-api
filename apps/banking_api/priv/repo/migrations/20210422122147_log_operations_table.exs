defmodule BankingApi.Repo.Migrations.LogOperationsTable do
  use Ecto.Migration

  def change do
    create table(:log_operations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :bigint
      add :operation_type, :string
      add :from_account_id, references(:accounts, type: :uuid), null: false
      add :to_account_id, references(:accounts, type: :uuid), null: false

      timestamps()
    end
  end
end
