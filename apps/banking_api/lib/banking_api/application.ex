defmodule BankingApi.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BankingApi.Repo,
      {Phoenix.PubSub, name: BankingApi.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BankingApi.Supervisor)
  end
end
