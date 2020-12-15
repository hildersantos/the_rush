defmodule TheRushWeb.PaginationComponent do
  @moduledoc false
  use TheRushWeb, :live_component

  alias TheRushWeb.HomeLive

  defp page_link(socket, opts) do
    default_classes = ~w{text-sm py-2 px-4 flex-1 border-r border-gray-300 text-center}

    classes =
      cond do
        opts[:link_to_page_number] == opts[:current_page] ->
          ["bg-purple-800 text-white" | default_classes]

        opts[:disabled] ->
          ["bg-white text-gray-800 opacity-50 cursor-not-allowed" | default_classes]

        true ->
          ["bg-white text-gray-800" | default_classes]
      end
      |> Enum.join(" ")

    if opts[:disabled] do
      raw("<span class=\"#{classes}\">#{opts[:label]}</span>")
    else
      live_patch(opts[:label],
        to:
          Routes.live_path(
            socket,
            HomeLive,
            sort_by: opts[:current_sort_by],
            sort_order: opts[:current_sort_order],
            page: opts[:link_to_page_number],
            per_page: opts[:current_per_page]
          ),
        class: classes
      )
    end
  end
end
