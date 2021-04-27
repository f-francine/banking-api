defmodule BankingApiWeb.Views.AccountsView do
  use BankingApiWeb, :view

  alias BankingApi.Accounts.Schemas.Account

  def render("create.json", %{account: %Account{id: _id, user: user, balance: balance}}) do
    %{
      message: "Account created",
      account: %{
        user: user,
        balance: balance
      }
    }
  end

  def render("account_info.json", balance) do
    %{
      message: "Your current balance is #{balance}"
    }
  end

  def render("withdraw_update.json", %{account: %Account{id: _id, user: user, balance: balance}}) do
    %{
      message: "Balance changed succesfully",
      account: %{
        user: user,
        balance: balance
      }
    }
  end

  def render("transaction_update.json", %{
        withdraw: %Account{id: _withdraw_id, user: withdraw_user, balance: withdraw_balance},
        deposit: %Account{id: _deposit_id, user: deposit_user, balance: deposit_balance}
      }) do
    %{
      message: "Transaction done succesfully",
      withdraw: %{
        user: withdraw_user,
        balance: withdraw_balance
      },
      deposit: %{
        user: deposit_user,
        balance: deposit_balance
      }
    }
  end
end
