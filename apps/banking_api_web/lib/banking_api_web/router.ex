defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankingApiWeb.Controllers do
    pipe_through :api

    post "/accounts", AccountsController, :create

    post "/accounts/withdraw", AccountsController, :withdraw

    post "/accounts/transaction", AccountsController, :transaction

    get "/accounts/:id", AccountsController, :show
  end
end
