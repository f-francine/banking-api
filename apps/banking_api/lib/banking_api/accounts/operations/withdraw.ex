defmodule BankingApi.Accounts.Operations.Withdraw do
  @moduledoc """
  Do a withdraw, when a valid user and a valid value are given
  """

  alias Ecto.Multi
  alias BankingApi.Accounts.Schemas.{Account, LogOperations}

  import Ecto.Query

  def call(%{"user" => user, "value" => value}) do
    Multi.new()
    |> Multi.run(:account, fn repo, _changes ->
      get_account(repo, user)
    end)
    |> Multi.run(:update_balance, fn repo, %{account: account} ->
      update_balance(repo, account, value)
    end)
    |> Multi.run(:save_transaction, fn repo,
                                       %{
                                         source_account: from,
                                         target_account: from
                                       } ->
      save_transaction(repo, from.id, from.id, value)
    end)
    |> BankingApi.Repo.transaction()
    |> case do
      {:ok, %{update_balance: update_balance}} -> {:ok, update_balance}
      {:error, _step, reason, _changes} -> {:error, reason}
    end
  end

  defp get_account(repo, user) do
    Account
    |> where([a], a.user == ^user)
    |> lock("FOR UPDATE")
    |> repo.one()
    |> case do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value) do
    balance = account.balance - value

    Account.changeset(account, %{balance: balance})
    |> repo.update()
  end

  defp save_transaction(repo, from, _from, value) do
    LogOperations.changeset(%{
      "from_account_id" => from,
      "to_account_id" => from,
      "value" => value,
      "operation_type" => "withdraw"
    })
    |> repo.insert()
  end
end
