defmodule BankingApiWeb.Views.AccountsView do

  alias BankingApi.Accounts

  def render("create.json", %{account: %Accounts{id: id, user: user, balance: balance}}) do
    %{
      message: "Account created",
      account: %{
        id: id,
        user: user,
        balance: balance
      }
    }
  end
end
