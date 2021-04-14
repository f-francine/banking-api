# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :banking_api,
  ecto_repos: [BankingApi.Repo]

config :banking_api_web,
  ecto_repos: [BankingApi.Repo],
  generators: [context_app: :banking_api, binary_id: true]

# Configures the endpoint
config :banking_api_web, BankingApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0V2vOuci9cQBT5SdnS8g2XOS45EeI82sG+we4uiSDTjUPflE2au49PVGbDNLbhBg",
  render_errors: [view: BankingApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankingApi.PubSub,
  live_view: [signing_salt: "AItDkhD5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
