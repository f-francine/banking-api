defmodule BankingApi.AccountsControllerTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.{Accounts, Repo}

  describe "create_account/1" do
    test "fails if user is already taken" do
      user = "Maxon"
      Repo.insert!({%Accounts{user: user}})

      assert {:error, %{}} == BankingApi.create_account(%{user: "Maxon"})
    end
  end
end
