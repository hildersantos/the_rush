defmodule TheRush.PlayerFixture do
  @moduledoc false

  @doc false
  def new(params \\ %{}) do
    {:ok, player} =
      params
      |> Enum.into(valid_params())
      |> TheRush.Players.create()

    player
  end

  def valid_params do
    %{
      name: "Silvio Santos",
      team: "SBT",
      position: "RB",
      attempts: 2,
      attempts_per_game: 2.0,
      yards_total: 7,
      rushing_average: 3.5,
      yards_per_game: 7.0,
      touchdowns: 0,
      longest_rush_value: 7,
      longest_rush_touchdown: false,
      first_downs: 0,
      first_downs_percentage: 0,
      yards_20: 0,
      yards_40: 0,
      fumbles: 0
    }
  end

  def invalid_params do
    %{
      name: nil,
      team: nil,
      position: nil,
      attempts: nil,
      attempts_per_game: nil,
      yards_total: nil,
      rushing_average: nil,
      yards_per_game: nil,
      touchdowns: nil,
      longest_rush_value: nil,
      longest_rush_touchdown: "bogus",
      first_downs: nil,
      first_downs_percentage: nil,
      yards_20: nil,
      yards_40: nil,
      fumbles: nil
    }
  end
end
