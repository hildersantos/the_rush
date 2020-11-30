defmodule TheRushWeb.HomeLive do
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
