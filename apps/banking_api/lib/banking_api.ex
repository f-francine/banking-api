defmodule BankingApi do

  alias BankingAPi.Accounts.CreateAccount

  defdelegate create_account(params), to: CreateAccount, as: :call
end
