defmodule BankingApiWeb.Controllers.AccountsController do
  @moduledoc """
  Account actions.
  """

  use BankingApiWeb, :controller

  alias BankingApiWeb.Views.{AccountsView, ErrorView}

  alias BankingApi.Accounts.Schemas
  alias BankingApi.Account

  alias Ecto.Changeset

  @doc """
  Create an account.
  """
  def create(conn, params) do
    case Account.create(params) do
      {:ok, %Schemas.Account{} = account} ->
        conn
        |> put_view(AccountsView)
        |> put_status(:created)
        |> render("create.json", account: account)

      {:error, %Changeset{} = changeset} ->
        conn
        |> put_view(ErrorView)
        |> put_status(:bad_request)
        |> render("400.json", result: changeset)
    end
  end

  def show(conn, %{"id" => account_id}) do
    with {:uuid, {:ok, _}} <- {:uuid, Ecto.UUID.cast(account_id)},
         {:ok, balance} <- Account.fetch(account_id) do
      send_json(conn, 200, %{description: "Your current balance is #{balance}"})
    else
      {:uuid, :error} ->
        send_json(conn, 400, %{type: "bad_input", description: "Not a proper UUID v4"})

      {:error, :not_found} ->
        send_json(conn, 404, %{type: "not_found", description: "Author not found"})
    end
  end

  @spec withdraw(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def withdraw(conn, params) do
    case Account.withdraw(params) do
      {:ok, %Schemas.Account{} = account} ->
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
    case Account.transaction(params) do
      {:ok, {%Schemas.Account{} = account1, %Schemas.Account{} = account2}} ->
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

  defp send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end
