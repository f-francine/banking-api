defmodule BankingApi do

  alias BankingAPi.Accounts.CreateAccount
  alias BankingApi.Accounts.Operations.Withdraw

  defdelegate create_account(params), to: CreateAccount, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
end
