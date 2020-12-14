defmodule TheRush.CsvEncoder do
  @moduledoc """
  Module for processing results into CSV
  """

  alias TheRush.Players

  @doc """
  Encodes a list of players and return its results
  """
  def encode_and_serve(criteria \\ []) do
    csv_header = [
      "Name",
      "Team",
      "Position",
      "Rushing Attempts Per Game Average",
      "Rushing Attempts",
      "Total Rushing Yards",
      "Rushing Average Yards Per Attempt",
      "Rushing Yards Per Game",
      "Total Rushing Touchdowns",
      "Longest Rush",
      "Rushing First Touchdowns",
      "Rushing First Down Percentage",
      "Rushing 20+ Yards Each",
      "Rushing 40+ Yards Each",
      "Rushing Fumbles"
    ]

    results =
      criteria
      |> Players.all()
      |> Enum.map(fn entry ->
        longest_rush_value = Integer.to_string(entry.longest_rush_value)

        longest_rush =
          (entry.longest_rush_touchdown && longest_rush_value <> "T") || longest_rush_value

        [
          entry.name,
          entry.team,
          entry.position,
          entry.attempts_per_game,
          entry.attempts,
          entry.yards_total,
          entry.rushing_average,
          entry.yards_per_game,
          entry.touchdowns,
          longest_rush,
          entry.first_downs,
          entry.first_downs_percentage,
          entry.yards_20,
          entry.yards_40,
          entry.fumbles
        ]
      end)

    [csv_header | results]
    |> CSV.Encoding.Encoder.encode()
    |> Enum.to_list()
    |> to_string()
  end
end
