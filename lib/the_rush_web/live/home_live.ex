defmodule TheRushWeb.HomeLive do
  @moduledoc """
  Module responsible for entries' table user interface.
  """
  use TheRushWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    assigns = [
      records: [],
      search_query: "",
      sort_by: nil
    ]

    {:ok, assign(socket, assigns)}
  end
end
