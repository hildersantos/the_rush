defmodule TheRush.Players.UserInterfaceFields do
  @moduledoc """
  This module acts as a helper for generating fields to be used in templates (e.g. generating tables).
  """

  @doc false
  def for_player do
    [
      name: %{
        label: "Name",
        sort_by: false
      },
      team: %{
        label: "Team",
        sort_by: false
      },
      position: %{
        label: "Position",
        sort_by: false
      },
      attempts: %{
        label: "Rushing Attempts",
        sort_by: false
      },
      attempts_per_game: %{
        label: "Rushing Attempts Per Game Average",
        sort_by: false
      },
      yards_total: %{
        label: "Total Rushing Yards",
        sort_by: true
      },
      rushing_average: %{
        label: "Rushing Average Yards Per Attempt",
        sort_by: false
      },
      yards_per_game: %{
        label: "Rushing Yards Per Game",
        sort_by: false
      },
      touchdowns: %{
        label: "Total Rushing Touchdowns",
        sort_by: true
      },
      longest_rush_value: %{
        label: "Longest Rush",
        sort_by: true,
        concatenate_with: [{:longest_rush_touchdown, " T"}]
      },
      first_downs: %{
        label: "Rushing First Downs",
        sort_by: false
      },
      first_downs_percentage: %{
        label: "Rushing First Downs Percentage",
        sort_by: false
      },
      yards_20: %{
        label: "Rushing 20+ Yards Each",
        sort_by: false
      },
      yards_40: %{
        label: "Rushing 40+ Yards Each",
        sort_by: false
      },
      fumbles: %{
        label: "Fumbles",
        sort_by: false
      }
    ]
  end
end
