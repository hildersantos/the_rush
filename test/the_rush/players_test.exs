defmodule TheRush.PlayersTest do
  use ExUnit.Case, async: true
  
  import ExUnit.CaptureLog

  alias TheRush.{
    Players,
    Players.Player
  }

  import Mox

  setup :verify_on_exit!

  test "create/1 creates a new player" do
    player = Players.create(%{player: "Oz"})

    assert {:ok, %Player{player: "Oz"}} = player
  end

  test "build_list/0 returns valid list of players" do
    # Testing with valid JSON entries should return them all
    TheRush.MockFiles
    |> expect(:fetch_json, 1, fn _filename ->
      valid_json_output()
    end)
    |> expect(:fetch_json, 1, fn _filename ->
      invalid_json_output()
    end)

    assert Players.build_list() |> length() == 3

    # Testing with invalid JSON entries should return
    # only the valid ones and warn about the bogused
    assert capture_log(fn ->
      assert Players.build_list() |> length() == 1
    end) =~ "invalid entry format"
  end

  defp valid_json_output do
    [
      %{
        "Player"=>"Joe Banyard",
        "Team"=>"JAX",
        "Pos"=>"RB",
        "Att"=>2,
        "Att/G"=>2,
        "Yds"=>7,
        "Avg"=>3.5,
        "Yds/G"=>7,
        "TD"=>0,
        "Lng"=>"7",
        "1st"=>0,
        "1st%"=>0,
        "20+"=>0,
        "40+"=>0,
        "FUM"=>0
      },
      %{
        "Player"=>"Shaun Hill",
        "Team"=>"MIN",
        "Pos"=>"QB",
        "Att"=>5,
        "Att/G"=>1.7,
        "Yds"=>5,
        "Avg"=>1,
        "Yds/G"=>1.7,
        "TD"=>0,
        "Lng"=>"9",
        "1st"=>0,
        "1st%"=>0,
        "20+"=>0,
        "40+"=>0,
        "FUM"=>0
      },
      %{
        "Player"=>"Mark Ingram",
        "Team"=>"NO",
        "Pos"=>"RB",
        "Att"=>205,
        "Att/G"=>12.8,
        "Yds"=>"1,043",
        "Avg"=>5.1,
        "Yds/G"=>65.2,
        "TD"=>6,
        "Lng"=>"75T",
        "1st"=>49,
        "1st%"=>23.9,
        "20+"=>4,
        "40+"=>2,
        "FUM"=>2
      },
    ]
  end

  defp invalid_json_output do
    [
      %{
        "Player"=>"Joe Banyard",
        "Team"=>"JAX",
        "Pos"=>"RB",
        "Att"=>2,
        "Att/G"=>2,
        "Yds"=>7,
        "Avg"=>3.5,
        "Yds/G"=>7,
        "TD"=>0,
        "Lng"=>"7",
        "1st"=>0,
        "1st%"=>0,
        "20+"=>0,
        "40+"=>0,
        "FUM"=>0
      },
      %{
        "Player"=>2,
        "Team"=>"MIN",
        "Pos"=>"QB",
        "Att"=>5,
        "Att/G"=>1.7,
        "Yds"=>5,
        "Avg"=>1,
        "Yds/G"=>1.7,
        "TD"=>0,
        "Lng"=>"T",
        "1st"=>0,
        "1st%"=>0,
        "20+"=>0,
        "40+"=>0,
        "FUM"=>0
      },
      %{
        "Player"=>"Mark Ingram",
        "Team"=> 2,
        "Pos"=>"RB",
        "Att"=>205,
        "Att/G"=>12.8,
        "Yds"=>"1,043",
        "Avg"=>5.1,
        "Yds/G"=>65.2,
        "TD"=>6,
        "Lng"=>"75T",
        "1st"=>49,
        "1st%"=>23.9,
        "20+"=>4,
        "40+"=>2,
        "FUM"=>2
      },
    ]
  end
end
