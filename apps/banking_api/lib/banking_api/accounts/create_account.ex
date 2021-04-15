defmodule BankingAPi.Accounts.CreateAccount do

  alias BankingApi.{Accounts, Repo}

  def call(params) do
    params
    |> Accounts.changeset()
    |> Repo.insert()
  end
end
