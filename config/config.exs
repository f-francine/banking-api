import Config

config :banking_api, BankingApi.Repo,
  database: "banking_api_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :banking_api,
  ecto_repos: [BankingApi.Repo]

config :banking_api_web,
  ecto_repos: [BankingApi.Repo],
  generators: [context_app: :banking_api, binary_id: true]

config :banking_api_web, BankingApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0V2vOuci9cQBT5SdnS8g2XOS45EeI82sG+we4uiSDTjUPflE2au49PVGbDNLbhBg",
  render_errors: [view: BankingApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankingApi.PubSub,
  live_view: [signing_salt: "AItDkhD5"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
