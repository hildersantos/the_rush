defmodule TheRush.Release do
  @moduledoc false
  @app :the_rush

  def migrate do
    load_app()

    for repo <- repos() do
      Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
      IO.puts("#{repo} migrated.")
    end
  end

  def seed do
    load_app()

    for repo <- repos() do
      Ecto.Migrator.with_repo(repo, &run_seeds_for/1)
    end
  end

  defp run_seeds_for(repo) do
    seed_script = seeds_path(repo)

    if File.exists?(seed_script) do
      IO.puts("Seeding database...")

      Code.eval_file(seed_script)

      IO.puts("Database seeded.")
    end
  end

  defp seeds_path(repo), do: priv_path_for(repo, "seeds.exs")

  defp priv_path_for(repo, filename) do
    repo_underscore = 
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    Path.join([priv_dir(@app), repo_underscore, filename])
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp load_app do
    Application.load(@app)
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end
end
