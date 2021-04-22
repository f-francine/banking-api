defmodule BankingAPi.Accounts.CreateAccount do
  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.Accounts

  def call(params) do
    params
    |> Accounts.changeset()
    |> Repo.insert()
  end
end
