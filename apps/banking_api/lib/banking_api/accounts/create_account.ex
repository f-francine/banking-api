defmodule BankingAPi.Accounts.CreateAccount do
  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.Account

  def call(params) do
    params
    |> Account.changeset()
    |> Repo.insert()
  end
end
