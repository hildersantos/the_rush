defmodule TheRushWeb.CsvControllerTest do
  use TheRushWeb.ConnCase

  alias TheRush.PlayerFixture

  test "creates a valid CSV", %{conn: conn} do
    ["PlayerA", "PlayerB", "PlayerC"]
    |> Enum.each(fn name ->
      PlayerFixture.new(%{name: name})
    end)

    criteria = %{
      filter_by_name: "PlayerA"
    }

    conn = post(conn, Routes.csv_path(conn, :create), criteria: criteria)

    assert response(conn, 201) =~ "PlayerA"
    refute response(conn, 201) =~ "PlayerB"
    refute response(conn, 201) =~ "PlayerC"
    assert get_resp_header(conn, "content-disposition") |> List.first() =~ "attachment"
    assert response_content_type(conn, :csv) =~ "charset=utf-8"
  end
end
