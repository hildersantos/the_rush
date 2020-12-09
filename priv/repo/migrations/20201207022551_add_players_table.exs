defmodule TheRush.Repo.Migrations.AddPlayersTable do
  use Ecto.Migration

  def change do
    create table("players") do
      add :name, :string
      add :position, :string
      add :team, :string
      add :attempts, :integer
      add :attempts_per_game, :float
      add :rushing_average, :float
      add :yards_total, :integer
      add :yards_per_game, :float
      add :touchdowns, :integer
      add :longest_rush_value, :integer
      add :longest_rush_touchdown, :boolean
      add :first_downs, :integer
      add :first_downs_percentage, :float
      add :yards_20, :integer
      add :yards_40, :integer
      add :fumbles, :integer

      timestamps()
    end
  end
end
