defmodule TheRush.PlayersTest do
  alias TheRush.Players
  import Mox
  use TheRush.DataCase

  setup :set_mox_from_context
  setup :verify_on_exit!

  @valid_params %{
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

  @invalid_params %{
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

  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(@valid_params)
      |> Players.create()

    player
  end

  test "build_list/0 returns valid list of players" do
    # Testing with valid JSON entries should return them all
    TheRush.MockFiles
    |> expect(:fetch_json, 1, fn _filename ->
      [
        %{
          "Player" => "Joe Banyard",
          "Team" => "JAX",
          "Pos" => "RB",
          "Att" => 2,
          "Att/G" => 2,
          "Yds" => 7,
          "Avg" => 3.5,
          "Yds/G" => 7,
          "TD" => 0,
          "Lng" => "7",
          "1st" => 0,
          "1st%" => 0,
          "20+" => 0,
          "40+" => 0,
          "FUM" => 0
        },
        %{
          "Player" => "Shaun Hill",
          "Team" => "MIN",
          "Pos" => "QB",
          "Att" => 5,
          "Att/G" => 1.7,
          "Yds" => 5,
          "Avg" => 1,
          "Yds/G" => 1.7,
          "TD" => 0,
          "Lng" => "9T",
          "1st" => 0,
          "1st%" => 0,
          "20+" => 0,
          "40+" => 0,
          "FUM" => 0
        }
      ]
    end)

    assert Players.build_list() == [
             %{
               name: "Joe Banyard",
               team: "JAX",
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
             },
             %{
               name: "Shaun Hill",
               team: "MIN",
               position: "QB",
               attempts: 5,
               attempts_per_game: 1.7,
               yards_total: 5,
               rushing_average: 1.0,
               yards_per_game: 1.7,
               touchdowns: 0,
               longest_rush_value: 9,
               longest_rush_touchdown: true,
               first_downs: 0,
               first_downs_percentage: 0,
               yards_20: 0,
               yards_40: 0,
               fumbles: 0
             }
           ]
  end

  test "create/1 with valid params creates a player" do
    {:ok, player} = Players.create(@valid_params)

    assert player.name == "Silvio Santos"
    assert player.team == "SBT"
  end

  test "create/1 with invalid params creates returns error" do
    assert {:error, changeset} = Players.create(@invalid_params)

    refute changeset.valid?
  end

  test "all/1 with pagination and sort returns paginated and sorted entries" do
    player_c = player_fixture(name: "C")
    player_fixture(name: "A")
    player_fixture(name: "B")

    # Get the entry at the third page (should be player "C")
    options = [
      pagination: %{page: 3, per_page: 1},
      sort: %{sort_by: :name, sort_order: :asc}
    ]

    assert [player_c] == Players.all(options)
  end
end
