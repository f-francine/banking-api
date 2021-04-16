defmodule BankingApi.Accounts.Operations.Deposit do
  alias Ecto.Multi
  alias BankingApi.Accounts

  import Ecto.Query
  def call(%{user: user, value: value}) do
    Multi.new()
    |> Multi.run(:account, fn repo, _changes ->
      get_account(repo, user)
    end)
    |> Multi.run(:update_balance, fn repo, %{account: account} ->
      update_balance(repo, account, value)
    end)
    |> BankingApi.Repo.transaction()
    |> case do
      {:ok, %{update_balance: update_balance}} -> {:ok, update_balance}
      {:error, _step, reason, _changes} -> {:error, reason}
    end
  end

  defp get_account(repo, user) do
    Accounts
    |> where([a], a.user == ^user)
    |> lock("FOR UPDATE")
    |> repo.one()
    |> case do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value) do
    balance = account.balance + value
    Accounts.changeset(account, %{balance: balance})
    |> repo.update()
  end
end