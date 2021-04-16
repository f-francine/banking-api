defmodule BankingApi.Accounts.Operations.Transaction do
  alias Ecto.Multi
  alias BankingApi.Accounts.Operations.{Deposit, Withdraw}

  def call(%{from: from_user, to: to_user, value: value}) do
    Multi.new()
    |> Multi.run(:withdraw, fn _repo, _changes ->
      Withdraw.call(%{user: from_user, value: value})
    end)
    |> Multi.run(:deposit, fn _repo, _changes ->
      Deposit.call(%{user: to_user, value: value})
    end)
    |> BankingApi.Repo.transaction()
    |> case do
      {:ok, %{withdraw: withdraw, deposit: deposit}} -> {:ok, withdraw, deposit}
      {:error, _step, reason, _changes} -> {:error, reason}
    end
  end
end
