defmodule BankingApi.Account do
  @moduledoc """
  Domain public functions about the authors context.
  """
  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.{Account, LogOperations}
  alias Ecto.Multi
  import Ecto.Query

  def create(params) do
    params
    |> Account.changeset()
    |> Repo.insert()
  end

  @spec withdraw(map) :: {:error, any} | {:ok, any}
  @doc """
  Withdraws to a valid user's account, when there is a balance limit available
  """
  def withdraw(%{"user" => user, "value" => value}) do
    Multi.new()
    |> Multi.run(:account, fn repo, _changes ->
      get_account(repo, user)
    end)
    |> Multi.run(:update_balance, fn repo, %{account: account} ->
      update_balance_withdraw(repo, account, value)
    end)
    # |> Multi.run(:save_transaction, fn repo, %{from_account: from} ->
    #   save_transaction(repo, from.id, value)
    # end)
    |> BankingApi.Repo.transaction()
    |> case do
      {:ok, %{update_balance: update_balance}} -> {:ok, update_balance}
      {:error, _step, reason, _changes} -> {:error, reason}
    end
  end

  @doc """
  Transaction between two valid accounts, when the balance limit is available
  """
  def transaction(%{"from" => from_user, "to" => to_user, "value" => value}) do
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
    |> Multi.run(:save_transaction, fn repo,
                                       %{
                                         source_account: from,
                                         target_account: to
                                       } ->
      save_transaction(repo, from.id, to.id, value)
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
    Account
    |> where([a], a.user == ^user)
    |> lock("FOR UPDATE")
    |> repo.one()
    |> case do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  defp update_balance_withdraw(repo, account, value) do
    balance = account.balance - value

    Account.changeset(account, %{balance: balance})
    |> repo.update()
  end

  defp update_balance_deposit(repo, account, value) do
    balance = account.balance + value

    Account.changeset(account, %{balance: balance})
    |> repo.update()
  end

  # defp save_transaction(repo, from, value) do
  #   LogOperations.changeset(%{
  #     "from_account_id" => from,
  #     "value" => value,
  #     "operation_type" => "withdraw"
  #   })
  #   |> repo.insert()
  # end

  defp save_transaction(repo, from, to, value) do
    LogOperations.changeset(%{
      "from_account_id" => from,
      "to_account_id" => to,
      "value" => value,
      "operation_type" => "transaction"
    })
    |> repo.insert()
  end

  @spec fetch(Ecto.UUID.t()) :: {:ok, Account.t()} | {:error, :not_found}
  def fetch(account_id) do
    from(a in BankingApi.Accounts.Schemas.Account, where: a.id == ^account_id, select: a.balance)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      balance -> {:ok, balance}
    end
  end
end
