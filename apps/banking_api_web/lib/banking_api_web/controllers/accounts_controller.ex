defmodule BankingApiWeb.Controllers.AccountsController do
  use BankingApiWeb, :controller

  alias BankingApiWeb.Views.AccountsView
  alias BankingApiWeb.Views.ErrorView
  alias Ecto.Changeset

  alias BankingApi.Accounts
  def create(conn, params) do
    case BankingApi.create_account(params) do
    {:error,  %Changeset{} = changeset} ->
      conn
      |> put_view(ErrorView)
      |> IO.inspect(label: "Create account")
      |> put_status(:bad_request)
      |> render("400.json", result: changeset)
    {:ok, %Accounts{} = account} ->
      conn
      |> put_view(AccountsView)
      |> put_status(:created)
      |> render("create.json", account: account)
    end
  end
end
