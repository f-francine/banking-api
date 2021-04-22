defmodule BankingApi.AccountsTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.Accounts

  describe "create_account/1" do
    test "sucessfully create an account when the params are valid" do
      assert {:ok, _account} = BankingApi.create_account(%{user: "Leia"})
    end

    test "fail if user already exists" do
      user = "Leia"
      Repo.insert!(%Accounts{user: user})
      assert {:error, _changeset} = BankingApi.create_account(%{user: user})
    end
  end

  describe "withdraw/1" do
    test "fail if user does not exist" do
      assert {:error, _reason} =
               BankingApi.withdraw(%{
                 "user" => "unkown",
                 "value" => 10
               })
    end

    test "fail if withdraw's value is bigger than current balance" do
      user = "Lynn"
      Repo.insert!(%Accounts{user: user})

      assert {:error, _reason} =
               BankingApi.withdraw(%{
                 "user" => "Lynn",
                 "value" => 100_000
               })
    end

    test "withdraw sucessfully done when all params are valid" do
      user = "Lynn"
      Repo.insert!(%Accounts{user: user})

      assert {:ok, _account} =
               BankingApi.withdraw(%{
                 "user" => "Lynn",
                 "value" => 100
               })
    end
  end

  describe "transaction/1" do
    test "fail if source account does not exist" do
      user1 = "Lynn"

      user2 = "Leia"
      Repo.insert!(%Accounts{user: user2})

      assert {:error, :account_not_found} =
               BankingApi.transaction(%{
                 "from" => user1,
                 "to" => user2,
                 "value" => 10
               })
    end

    test "fail if target account does not exist" do
      user1 = "Leia"
      Repo.insert!(%Accounts{user: user1})

      user2 = "Lynn"

      assert {:error, :account_not_found} =
               BankingApi.transaction(%{
                 "from" => user1,
                 "to" => user2,
                 "value" => 10
               })
    end

    test "fail if withdraw value from source account is bigger than the current balance" do
      user1 = "Lynn"
      Repo.insert!(%Accounts{user: user1})

      user2 = "Leia"
      Repo.insert!(%Accounts{user: user2})

      assert {:error, _changeset} =
               BankingApi.transaction(%{
                 "from" => user1,
                 "to" => user2,
                 "value" => 1_000_000
               })
    end

    test "transaction sucessfully done when all params are valid" do
      user1 = "Lynn"
      Repo.insert!(%Accounts{user: user1})

      user2 = "Leia"
      Repo.insert!(%Accounts{user: user2})

      assert {:ok, _account1, _account2} =
               BankingApi.transaction(%{
                 "from" => user1,
                 "to" => user2,
                 "value" => 10
               })
    end
  end
end
