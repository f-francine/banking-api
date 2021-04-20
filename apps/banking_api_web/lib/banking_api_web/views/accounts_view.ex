defmodule BankingApiWeb.Views.AccountsView do
  alias BankingApi.Accounts

  @spec render(<<_::88, _::_*24>>, map) :: %{
          :message => <<_::64, _::_*8>>,
          optional(:account) => %{balance: any, id: any, user: any},
          optional(:deposit) => %{balance: any, id: any, user: any},
          optional(:withdraw) => %{balance: any, id: any, user: any}
        }
  def render("create.json", %{account: %Accounts{id: _id, user: user, balance: balance}}) do
    %{
      message: "Account created",
      account: %{
        user: user,
        balance: balance
      }
    }
  end

  def render("withdraw_update.json", %{account: %Accounts{id: _id, user: user, balance: balance}}) do
    %{
      message: "Balance changed succesfully",
      account: %{
        user: user,
        balance: balance
      }
    }
  end

  def render("transaction_update.json", %{
        withdraw: %Accounts{id: _withdraw_id, user: withdraw_user, balance: withdraw_balance},
        deposit: %Accounts{id: _deposit_id, user: deposit_user, balance: deposit_balance}
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
