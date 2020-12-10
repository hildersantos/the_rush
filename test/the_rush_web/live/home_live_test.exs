defmodule TheRushWeb.HomeLiveTest do
  use TheRushWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Name"
    assert render(page_live) =~ "Name"
  end
end
