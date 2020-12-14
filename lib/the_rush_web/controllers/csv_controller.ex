defmodule TheRushWeb.CsvController do
  alias TheRush.CsvEncoder
  use TheRushWeb, :controller

  action_fallback TheRushWeb.FallbackController

  def create(conn, %{"criteria" => params}) do
    timestamp = :os.system_time(:millisecond) |> Integer.to_string()

    sort_by = (params["sort_by"] || "name") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()
    filter_by_name = params["filter_by_name"] || ""

    query = [
      sort: %{
        sort_by: sort_by,
        sort_order: sort_order
      },
      filter_by_name: filter_by_name
    ]

    conn
    |> put_resp_content_type("text/csv")
    |> put_secure_browser_headers()
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"players_" <> timestamp <> ".csv"
    )
    |> send_resp(201, CsvEncoder.encode_and_serve(query))
  end
end
