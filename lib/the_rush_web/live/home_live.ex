defmodule TheRushWeb.HomeLive do
  @moduledoc """
  Module responsible for entries' table user interface.
  """
  use TheRushWeb, :live_view

  alias TheRush.Players

  @per_page 20

  @impl true
  def mount(_params, _session, socket) do
    # Default values
    pagination_opts = %{page: 1, per_page: @per_page}
    sort_opts = %{sort_by: :name, sort_order: :asc}

    assigns = [
      options: Map.merge(pagination_opts, sort_opts),
      players: Players.all(
        pagination: pagination_opts,
        sort: sort_opts
      )
    ]

    {:ok, assign(socket, assigns), temporary_assigns: [players: []]}
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
      players: Players.all(
        pagination: pagination_opts,
        sort: sort_opts
      )
    ]

    {:noreply, assign(socket, assigns)}
  end
end
