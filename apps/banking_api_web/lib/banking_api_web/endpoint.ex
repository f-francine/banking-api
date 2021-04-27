defmodule BankingApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :banking_api_web

  @session_options [
    store: :cookie,
    key: "_banking_api_web_key",
    signing_salt: "htgB4Huo"
  ]

  socket "/socket", BankingApiWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :banking_api_web,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :banking_api_web
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BankingApiWeb.Router
end
