defmodule BankingApiWeb.Controllers.AccountsController do
  use BankingApiWeb, :controller

  alias BankingApiWeb.Views.{AccountsView, ErrorView}
  alias Ecto.Changeset
  alias BankingApi.Accounts

  def create(conn, params) do
    case BankingApi.create_account(params) do
      {:ok, %Accounts{} = account} ->
        conn
        |> put_view(AccountsView)
        |> put_status(:created)
        |> render("create.json", account: account)

      {:error, %Changeset{} = changeset} ->
        conn
        |> put_view(ErrorView)
        |> IO.inspect(label: "Create account")
        |> put_status(:bad_request)
        |> render("400.json", result: changeset)
    end
  end

  def withdraw(conn, params) do
    case BankingApi.withdraw(params) do
      {:ok, %Accounts{} = account} ->
        conn
        |> put_view(AccountsView)
        |> put_status(:ok)
        |> render("withdraw_update.json", account: account)

      {:error, %Changeset{} = changeset} ->
        conn
        |> put_view(ErrorView)
        |> put_status(:bad_request)
        |> render("400.json", result: changeset)

      {:error, :account_not_found} ->
        conn
        |> put_view(ErrorView)
        |> put_status(404)
        |> render("404.json", result: :account_not_found)
    end
  end

  def transaction(conn, params) do
    case BankingApi.transaction(params) do
      {:ok, %Accounts{} = account1, %Accounts{} = account2} ->
        conn
        |> put_view(AccountsView)
        |> put_status(:ok)
        |> render("transaction_update.json", withdraw: account1, deposit: account2)

      {:error, :account_not_found} ->
        conn
        |> put_view(ErrorView)
        |> put_status(404)
        |> render("404.json", result: :account_not_found)

      {:error, %Changeset{} = changeset} ->
        conn
        |> put_view(ErrorView)
        |> put_status(400)
        |> render("400.json", result: changeset)
    end
  end
end
