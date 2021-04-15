defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  alias Controllers.AccountsController

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankingApiWeb do
    pipe_through :api

    post "/accounts", AccountsController, :create
  end
end
