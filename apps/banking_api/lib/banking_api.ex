defmodule BankingApi do

  alias BankingAPi.Accounts.CreateAccount
  alias BankingApi.Accounts.Operations.{Transaction, Withdraw}

  defdelegate create_account(params), to: CreateAccount, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
end
