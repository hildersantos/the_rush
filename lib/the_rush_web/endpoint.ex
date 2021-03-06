defmodule TheRushWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :the_rush

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_the_rush_key",
    signing_salt: "IRpIgXtj"
  ]

  socket "/socket", TheRushWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :the_rush,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :the_rush
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug TheRushWeb.Router

  def init(_type, config) do
    config = Keyword.merge(config, runtime_config(), &update_if_nil/3)

    {:ok, config}
  end

  def runtime_config do
    env = System.get_env()

    [
      url: [
        host: env["THERUSH_HOSTNAME"] || "localhost"
      ],
      http: [
        port: String.to_integer(env["THERUSH_PORT"] || "4004"),
        transport_options: [
          socket_opts: [:inet6]
        ]
      ],
      secret_key_base: env["THERUSH_SECRET"],
      server: true
    ]
  end

  # Update keys only if they don't exist
  defp update_if_nil(_k, v1, nil), do: v1
  defp update_if_nil(_k, _, v2), do: v2
end
