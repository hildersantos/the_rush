# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :the_rush,
  ecto_repos: [TheRush.Repo]

# Configures the endpoint
config :the_rush, TheRushWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WZRKXq8rWPUxOseKIpHFoEuBOt/HO+Zlv7dV2K+k/7PGvGFmP6wIoNw1PiWrIbK1",
  render_errors: [view: TheRushWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TheRush.PubSub,
  live_view: [signing_salt: "G6YUN/6g"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
