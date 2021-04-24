defmodule BankingApiWeb.Controllers.AccountsControllerTest do
  use BankingApiWeb.ConnCase, async: true

  alias BankingApi.Repo
  alias BankingApi.Accounts.Schemas.Account

  describe "POST /api/accounts" do
    test "sucessfully create an account when params are valid", ctx do
      user = %{user: "Han"}

      assert %{
               "account" => %{"balance" => 1000, "user" => "Han"},
               "message" => "Account created"
             } =
               ctx.conn
               |> post("/api/accounts", user)
               |> json_response(:created)
    end

    test "fail with 400 when user is already taken", ctx do
      Repo.insert!(%Account{user: "Han"})
      user = %{user: "Han"}

      assert %{
               "message" => %{"user" => ["has already been taken"]}
             } =
               ctx.conn
               |> post("/api/accounts", user)
               |> json_response(:bad_request)
    end
  end

  describe "POST /api/accounts/transaction" do
    test "fail with 404 when one of users does not exist", ctx do
      input = %{from: "banana", to: "morango", value: 10}

      assert %{"reason" => "Account not found"} =
               ctx.conn
               |> post("/api/accounts/transaction", input)
               |> json_response(:not_found)
    end

    test "fail with 400 when withdraw value is bigger than current balnce", ctx do
      Repo.insert!(%Account{user: "Han"})
      Repo.insert!(%Account{user: "Maxon"})

      input = %{from: "Han", to: "Maxon", value: 100_000}

      assert %{"message" => %{"balance" => ["must be greater than or equal to 0"]}} =
               ctx.conn
               |> post("/api/accounts/transaction", input)
               |> json_response(:bad_request)
    end

    test "sucessfully done transaction when all params are valid", ctx do
      Repo.insert!(%Account{user: "Han"})
      Repo.insert!(%Account{user: "Maxon"})

      input = %{from: "Han", to: "Maxon", value: 10}

      assert %{"message" => "Transaction done succesfully"} =
               ctx.conn
               |> post("/api/accounts/transaction", input)
               |> json_response(:ok)
    end
  end

  describe "POST /api/accounts/withdraw" do
    test "fail if user does not exist", ctx do
      input = %{user: "unkown", value: 10}

      assert %{"reason" => "Account not found"} =
               ctx.conn
               |> post("/api/accounts/withdraw", input)
               |> json_response(:not_found)
    end

    test "fail if widraw value is bigger than current balance", ctx do
      Repo.insert!(%Account{user: "Han"})

      input = %{user: "Han", value: 10000}

      assert %{"message" => %{"balance" => ["must be greater than or equal to 0"]}} =
               ctx.conn
               |> post("/api/accounts/withdraw", input)
               |> json_response(:bad_request)
    end

    test "sucessfully done withdraw when all params are valid", ctx do
      Repo.insert!(%Account{user: "Han"})

      input = %{user: "Han", value: 10}

      assert %{"message" => "Balance changed succesfully"} =
               ctx.conn
               |> post("/api/accounts/withdraw", input)
               |> json_response(:ok)
    end
  end
end
