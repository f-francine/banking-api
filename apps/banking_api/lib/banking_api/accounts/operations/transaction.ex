defmodule BankingApi.Accounts.Operations.Transaction do
  @moduledoc """
  Do a transaction, when valid params are passed
  """
  alias Ecto.Multi
  alias BankingApi.Accounts.Schemas.Accounts
  import Ecto.Query

  def call(%{"from" => from_user, "to" => to_user, "value" => value}) do
    Multi.new()
    |> Multi.run(:source_account, fn repo, _changes ->
      get_account(repo, from_user)
    end)
    |> Multi.run(:target_account, fn repo, _changes ->
      get_account(repo, to_user)
    end)
    |> Multi.run(:update_balance_withdraw, fn repo, %{source_account: account} ->
      update_balance_withdraw(repo, account, value)
    end)
    |> Multi.run(:update_balance_deposit, fn repo, %{target_account: account} ->
      update_balance_deposit(repo, account, value)
    end)
    |> BankingApi.Repo.transaction()
    |> case do
      {:ok,
       %{
         source_account: _source,
         target_account: _target,
         update_balance_deposit: deposit,
         update_balance_withdraw: withdraw
       }} ->
        {:ok, withdraw, deposit}

      {:error, _step, reason, _changes} ->
        {:error, reason}
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

  defp update_balance_deposit(repo, account, value) do
    balance = account.balance + value

    Accounts.changeset(account, %{balance: balance})
    |> repo.update()
  end

  defp update_balance_withdraw(repo, account, value) do
    balance = account.balance - value

    Accounts.changeset(account, %{balance: balance})
    |> repo.update()
  end
end
