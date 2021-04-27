defmodule BankingApiWeb.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      BankingApiWeb.Telemetry,
      BankingApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: BankingApiWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BankingApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
