defmodule BankingApiWeb.Controllers.AccountsController do
  use BankingApiWeb, :controller

  alias BankingApiWeb.Views.AccountsView

  alias BankingApi.Accounts
  def create(conn, params) do
    with {:ok, %Accounts{} = account} <- BankingApi.create_account(params) do
      conn
      |> put_view(AccountsView)
      |> IO.inspect(label: "Create account")
      |> put_status(:created)
      |> render("create.json", account: account)
    end
  end

  # defp handle_response({:ok, %Accounts{} = account}, conn) do
  #   conn
  #   |> put_view(AccountsView)
  #   |> put_status(:created)
  #   |> render("create.json", account: account)
  # end
end
