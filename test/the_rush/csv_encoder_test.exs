defmodule TheRush.CsvEncoderTest do
  alias TheRush.{CsvEncoder, PlayerFixture}
  use TheRush.DataCase

  test "encode/1 returns a valid csv from results" do
    PlayerFixture.new(%{name: "A"})
    PlayerFixture.new(%{name: "B"})
    PlayerFixture.new(%{name: "C"})

    assert CsvEncoder.encode_and_serve() ==
      "Name,Team,Position,Rushing Attempts Per Game Average,Rushing Attempts,Total Rushing Yards,Rushing Average Yards Per Attempt,Rushing Yards Per Game,Total Rushing Touchdowns,Longest Rush,Rushing First Touchdowns,Rushing First Down Percentage,Rushing 20+ Yards Each,Rushing 40+ Yards Each,Rushing Fumbles\r\nA,SBT,RB,2.0,2,7,3.5,7.0,0,7,0,0.0,0,0,0\r\nB,SBT,RB,2.0,2,7,3.5,7.0,0,7,0,0.0,0,0,0\r\nC,SBT,RB,2.0,2,7,3.5,7.0,0,7,0,0.0,0,0,0\r\n"
  end
end
