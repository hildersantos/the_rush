defmodule TheRushWeb.HomeLive do
  @moduledoc """
  Module responsible for entries' table user interface.
  """
  use TheRushWeb, :live_view

  alias TheRush.Players
  alias TheRush.Players.UserInterfaceFields, as: Fields

  alias TheRushWeb.{
    DownloadCsvComponent,
    FilterNameComponent,
    PaginationComponent,
    TableComponent
  }

  @impl true
  def mount(_params, _session, socket) do
    # Default values
    pagination_opts = %{page: 1, per_page: per_page()}
    sort_opts = %{sort_by: :name, sort_order: :asc}

    assigns = [
      options: Map.merge(pagination_opts, sort_opts),
      players:
        Players.all(
          pagination: pagination_opts,
          sort: sort_opts
        ),
      filter_by_name: %{
        query: nil,
        debouncer_reference: nil
      },
      max_page: calculate_max_page(per_page())
    ]

    {:ok, assign(socket, assigns), temporary_assigns: [players: nil]}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "#{per_page()}")
    sort_by = (params["sort_by"] || "name") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    pagination_opts = %{page: page, per_page: per_page}
    sort_opts = %{sort_by: sort_by, sort_order: sort_order}

    assigns = [
      options: Map.merge(pagination_opts, sort_opts),
      players:
        Players.all(
          pagination: pagination_opts,
          sort: sort_opts,
          filter_by_name: socket.assigns.filter_by_name.query
        ),
      max_page: calculate_max_page(per_page, filter_by_name: socket.assigns.filter_by_name.query)
    ]

    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("filter_by_name", %{"query" => query}, socket) do
    # Let's store the query in the socket, so we can use it later
    # when the debouncer timer finishes
    socket =
      assign(socket, :filter_by_name, %{socket.assigns.filter_by_name | query: String.trim(query)})

    # Store the timeout in the socket
    debouncer_reference = socket.assigns.filter_by_name.debouncer_reference

    # Cancel the timer if exists
    debouncer_reference && Process.cancel_timer(debouncer_reference)

    # Assigns a reference to the timer in the socket
    socket =
      assign(socket, :filter_by_name, %{
        socket.assigns.filter_by_name
        | debouncer_reference: Process.send_after(self(), :filter_table, debouncer_timeout())
      })

    {:noreply, socket}
  end

  @impl true
  def handle_info(:filter_table, socket) do
    # Filter table based on filter_by_name.query
    %{per_page: per_page, sort_by: sort_by, sort_order: sort_order} = socket.assigns.options
    query = socket.assigns.filter_by_name.query

    pagination_opts = %{page: 1, per_page: per_page}
    sort_opts = %{sort_by: sort_by, sort_order: sort_order}

    socket =
      assign(
        socket,
        players:
          Players.all(
            filter_by_name: query,
            pagination: pagination_opts,
            sort: sort_opts
          ),
        max_page: calculate_max_page(per_page, filter_by_name: query)
      )

    {:noreply, socket}
  end

  # Helper & Template functions
  defp player_fields do
    Fields.for_player()
  end

  defp calculate_max_page(per_page, criteria \\ []) do
    total_count = Players.total_count(criteria)

    floor(total_count / per_page) + 1
  end

  defp per_page do
    System.get_env("RESULTS_PER_PAGE", "20")
    |> String.to_integer()
  end

  defp debouncer_timeout do
    System.get_env("DEBOUNCER_TIMEOUT", "500")
    |> String.to_integer()
  end
end
