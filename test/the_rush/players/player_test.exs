defmodule TheRush.Players.PlayerTest do
  use ExUnit.Case

  alias TheRush.Players.Player

  describe "new/1" do
    test "returns default struct with no arguments" do
      player = Player.new()

      assert %Player{
        player: "",
        team: "",
        position: "",
        attempts: 0,
        attempts_per_game: 0,
        yards_total: 0,
        yards_per_game: 0,
        touchdowns: 0,
        longest_rush: "",
        first_downs: 0,
        first_downs_percentage: 0,
        yards_20: 0,
        yards_40: 0,
        fumbles: 0
      } == player
    end

    test "returns valid struct with hydrated params" do
      params = valid_params()
      player = Player.new(params)

      assert %Player{
        player: params.player,
        team: params.team,
        position: params.position,
        attempts: params.attempts,
        attempts_per_game: params.attempts_per_game,
        yards_total: params.yards_total,
        yards_per_game: params.yards_per_game,
        touchdowns: params.touchdowns,
        longest_rush: params.longest_rush,
        first_downs: params.first_downs,
        first_downs_percentage: params.first_downs_percentage,
        yards_20: params.yards_20,
        yards_40: params.yards_40,
        fumbles: params.fumbles 
      } == player
    end
  end

  describe "validate_input/1" do
    test "returns valid map when conformed" do
      assert {:ok, validated} = Player.validate_input(valid_params())
      assert validated == valid_params()
    end

    test "returns error when map is invalid" do
      assert {:error, errors} = Player.validate_input(invalid_params())
      assert [%{path: [:longest_rush]},%{path: [:player]},%{path: [:yards_total]}] = errors
    end

    test "returns error when not passing a map as argument" do
      assert {:error, "Invalid data"} == Player.validate_input("not a map")
    end
  end

  defp valid_params do
    %{
      player: "John Appleseed",
      team: "Rushers",
      position: "QB",
      attempts: 3,
      attempts_per_game: 1.2,
      yards_total: 100,
      yards_per_game: 30.5,
      touchdowns: 10,
      longest_rush: %{
        value: 100,
        touchdown: false
      },
      first_downs: 1,
      first_downs_percentage: 1,
      yards_20: 1,
      yards_40: 2,
      fumbles: 3
    }
  end

  defp invalid_params do
    %{
      player: 100_000,
      team: "Rushers",
      position: "QB",
      attempts: 3,
      attempts_per_game: 1.2,
      yards_total: "100AB",
      yards_per_game: 30.5,
      touchdowns: 10,
      longest_rush: "T",
      first_downs: 1,
      first_downs_percentage: 1,
      yards_20: 1,
      yards_40: 2,
      fumbles: 3
    }
  end
end
