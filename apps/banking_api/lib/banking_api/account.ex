defmodule BankingApi.Account do
  @moduledoc """
  Domain public functions about the authors context.
  """
  import Ecto.Query

  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.{Account, LogOperations}

  require Logger

  def create(params) do
    params
    |> Account.changeset()
    |> Repo.insert()
  end

  @doc """
  Withdraws to a valid user's account, when there is a balance limit available
  """
  @spec withdraw(map) :: {:error, any} | {:ok, any}
  def withdraw(%{"user" => user, "value" => value}) do
    Repo.with_transaction(fn ->
      with {:ok, account} <- get_account(user),
           {:ok, update_balance} <- update_balance_withdraw(account, value) do
        {:ok, update_balance}
      else
        {:error, reason} = err ->
          Logger.error("Error while performing a withdrawal. Reason: #{inspect(reason)}")
          err
      end
    end)
  end

  @doc """
  Transaction between two valid accounts, when the balance limit is available.any()

  Returns the updated withdrawn account and the deposited account.
  """
  @spec transaction(params :: map) ::
          {:ok, {withdrawn :: Account.t(), deposited :: Account.t()}} | {:error, reason :: any()}
  def transaction(%{"from" => from_user, "to" => to_user, "value" => value}) do
    Repo.with_transaction(fn ->
      with {:ok, source_account} <- get_account(from_user),
           {:ok, target_account} <- get_account(to_user),
           {:ok, withdrawal} <- update_balance_withdraw(source_account, value),
           {:ok, deposit} <- update_balance_deposit(target_account, value),
           {:ok, _result} <- save_transaction(source_account.id, target_account.id, value) do
        {:ok, {withdrawal, deposit}}
      else
        {:error, reason} = err ->
          Logger.error("Error while performing a withdrawal. Reason: #{inspect(reason)}")
          err
      end
    end)
  end

  defp get_account(user) do
    Account
    |> where([a], a.user == ^user)
    |> lock("FOR UPDATE")
    |> Repo.one()
    |> case do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  defp update_balance_withdraw(account, value) do
    balance = account.balance - value

    account
    |> Account.changeset(%{balance: balance})
    |> Repo.update()
  end

  defp update_balance_deposit(account, value) do
    balance = account.balance + value

    account
    |> Account.changeset(%{balance: balance})
    |> Repo.update()
  end

  defp save_transaction(from, to, value) do
    LogOperations.changeset(%{
      "from_account_id" => from,
      "to_account_id" => to,
      "value" => value,
      "operation_type" => "transaction"
    })
    |> Repo.insert()
  end

  @spec fetch(Ecto.UUID.t()) :: {:ok, Account.t()} | {:error, :not_found}
  def fetch(account_id) do
    from(a in Account, where: a.id == ^account_id, select: a.balance)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      balance -> {:ok, balance}
    end
  end
end
