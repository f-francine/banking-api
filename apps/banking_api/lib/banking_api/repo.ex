defmodule BankingApi.Repo do
  use Ecto.Repo,
    otp_app: :banking_api,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Run function inside a transaction.

  It must return either: `{:ok, value}` or `{:error, reason}`.
  """
  def with_transaction(function) do
    transaction(fn ->
      case function.() do
        {:ok, value} -> value
        {:error, reason} -> rollback(reason)
      end
    end)
  end
end
