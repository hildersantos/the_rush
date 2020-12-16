import Config

config :logger, level: :info

config :the_rush, TheRush.Repo,
  username: :runtime,
  password: :runtime,
  database: :runtime,
  hostname: :runtime, 
  pool_size: :runtime
