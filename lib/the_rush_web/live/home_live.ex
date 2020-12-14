defmodule TheRushWeb.HomeLive do
  @moduledoc """
  Module responsible for entries' table user interface.
  """
  use TheRushWeb, :live_view

  alias TheRush.Players

  @per_page 50
  # Set a default timeout for the debouncer function, in ms
  @debouncer_timeout 500

  @impl true
  def mount(_params, _session, socket) do
    # Default values
    pagination_opts = %{page: 1, per_page: @per_page}
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
      max_page: calculate_max_page(@per_page)
    ]

    {:ok, assign(socket, assigns), temporary_assigns: [players: nil]}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "#{@per_page}")
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
        | debouncer_reference: Process.send_after(self(), :filter_table, @debouncer_timeout)
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

  defp sort_link(socket, text, sort_by, options) do
    text =
      if sort_by == options.sort_by do
        raw(text <> sort_icon(options.sort_order))
      else
        text
      end

    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_by: sort_by,
          sort_order: maybe_toggle_sort_order(sort_by, options),
          page: options.page,
          per_page: options.per_page
        )
    )
  end

  defp page_link(socket, text, page, options) do
    %{sort_by: sort_by, sort_order: sort_order, per_page: per_page} = options

    default_classes = ~w{text-sm py-2 px-4 flex-1 border-r border-gray-300 text-center}

    classes =
      if page == options.page do
        ["bg-purple-800 text-white" | default_classes]
      else
        ["bg-white text-gray-800" | default_classes]
      end

    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_by: sort_by,
          sort_order: sort_order,
          page: page,
          per_page: per_page
        ),
      class: Enum.join(classes, " ")
    )
  end

  defp calculate_max_page(per_page, criteria \\ []) do
    total_count = Players.total_count(criteria)

    floor(total_count / per_page) + 1
  end

  defp maybe_toggle_sort_order(sort_by, options)
       when sort_by == options.sort_by,
       do: toggle_sort_order(options.sort_order)

  defp maybe_toggle_sort_order(_, _), do: :asc

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp sort_icon(:asc) do
    """
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20">
      <path d="M3 3a1 1 0 000 2h11a1 1 0 100-2H3zM3 7a1 1 0 000 2h5a1 1 0 000-2H3zM3 11a1 1 0 100 2h4a1 1 0 100-2H3zM13 16a1 1 0 102 0v-5.586l1.293 1.293a1 1 0 001.414-1.414l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 101.414 1.414L13 10.414V16z" />
      </svg>
    """
  end

  defp sort_icon(:desc) do
    """
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20">
      <path d="M3 3a1 1 0 000 2h11a1 1 0 100-2H3zM3 7a1 1 0 000 2h7a1 1 0 100-2H3zM3 11a1 1 0 100 2h4a1 1 0 100-2H3zM15 8a1 1 0 10-2 0v5.586l-1.293-1.293a1 1 0 00-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L15 13.586V8z" />
      </svg>
    """
  end
end
