defmodule TheRush.PlayersTest do
  alias TheRush.{Players, PlayerFixture}
  import Mox
  use TheRush.DataCase

  setup :set_mox_from_context
  setup :verify_on_exit!

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
    valid_params = PlayerFixture.valid_params()
    {:ok, player} = Players.create(valid_params)

    assert player.name == "Silvio Santos"
    assert player.team == "SBT"
  end

  test "create/1 with invalid params creates returns error" do
    invalid_params = PlayerFixture.invalid_params()
    assert {:error, changeset} = Players.create(invalid_params)

    refute changeset.valid?
  end

  test "all/1 with pagination and sort returns paginated and sorted entries" do
    player_c = PlayerFixture.new(name: "C")
    PlayerFixture.new(name: "A")
    PlayerFixture.new(name: "B")

    # Get the entry at the third page (should be player "C")
    options = [
      pagination: %{page: 3, per_page: 1},
      sort: %{sort_by: :name, sort_order: :asc}
    ]

    assert [player_c] == Players.all(options)
  end

  test "all/1 with search query returns results" do
    player_adam = PlayerFixture.new(name: "Adam")
    player_bruno = PlayerFixture.new(name: "Bruno")
    player_colling = PlayerFixture.new(name: "Collin")
    player_delucca = PlayerFixture.new(name: "De_Lucca")
    player_emagic = PlayerFixture.new(name: "E-magic")

    assert [
             player_adam,
             player_bruno,
             player_colling,
             player_delucca,
             player_emagic
           ] ==
             Players.all(
               pagination: %{page: 1, per_page: 10},
               sort: %{sort_by: :name, sort_order: :asc}
             )

    assert [player_adam] ==
             Players.all(
               pagination: %{page: 1, per_page: 10},
               sort: %{sort_by: :name, sort_order: :asc},
               filter_by_name: "Ada"
             )

    assert [player_delucca] ==
             Players.all(
               pagination: %{page: 1, per_page: 10},
               sort: %{sort_by: :name, sort_order: :asc},
               filter_by_name: "De_"
             )

    assert [player_emagic] ==
             Players.all(
               pagination: %{page: 1, per_page: 10},
               sort: %{sort_by: :name, sort_order: :asc},
               filter_by_name: "E-"
             )
  end

  test "count/0 returns the total number of players" do
    Enum.each(~w{a b c d e f g h i}, fn name ->
      PlayerFixture.new(%{name: name})
    end)

    assert 9 == Players.total_count()
  end
end
