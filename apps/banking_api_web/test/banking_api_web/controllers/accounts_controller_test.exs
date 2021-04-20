defmodule BankingApiWeb.Controllers.AccountsControllerTest do
  use BankingApiWeb.ConnCase, async: true

  alias BankingApi.{Accounts, Repo}

  describe "POST /api/accounts" do
    test "sucessfully create an account when the params are valid" do
      assert {:ok, account} = BankingApi.create_account(%{user: "Han"})
    end
  end
end
