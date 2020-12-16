defmodule TheRush.Repo do
  use Ecto.Repo,
    otp_app: :the_rush,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    config = Keyword.merge(config, runtime_config(), &update_if_not_exists/3)

    {:ok, config}
  end

  def runtime_config() do
    env = System.get_env()

    [
      hostname: env["DB_HOSTNAME"],
      database: env["DB_NAME"],
      username: env["DB_USER"],
      password: env["DB_PASSWORD"],
      pool_size: String.to_integer(env["DB_POOL"] || "10")
    ]
  end

  # Set variables from runtime only if they are explicited
  defp update_if_not_exists(_k, :runtime, v2), do: v2
  defp update_if_not_exists(_k, v1, _), do: v1
end
