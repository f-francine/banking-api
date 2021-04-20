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

  def render("withdraw_update.json", %{account: %Accounts{id: id, user: user, balance: balance}}) do
    %{
      message: "Balance changed succesfully",
      account: %{
        id: id,
        user: user,
        balance: balance
      }
    }
  end

  def render("transaction_update.json", %{withdraw: %Accounts{id: withdraw_id, user: withdraw_user, balance: withdraw_balance}, deposit: %Accounts{id: deposit_id, user: deposit_user, balance: deposit_balance}}) do
    %{
      message: "Transaction done succesfully",
      withdraw: %{
        id: withdraw_id,
        user: withdraw_user,
        balance: withdraw_balance
      },

      deposit: %{
        id: deposit_id,
        user: deposit_user,
        balance: deposit_balance
      }
    }
  end
end
