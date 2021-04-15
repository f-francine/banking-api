defmodule BankingApiWeb.Controllers.AccountsController do
  use BankingApiWeb, :controller

  alias BankingApiWeb.Views.AccountsView

  alias BankingApi.Accounts
  def create(conn, params) do
    params
    |> BankingApi.create_account()
    |> IO.inspect(label: "Create account")
    |> handle_response(conn)
  end

  defp handle_response({:ok, %Accounts{} = account}, conn) do
    conn
    |> put_view(AccountsView)
    |> put_status(:created)
    |> render("create.json", account: account)
  end
end
