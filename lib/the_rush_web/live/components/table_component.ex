defmodule TheRushWeb.TableComponent do
  @moduledoc false
  use TheRushWeb, :live_component

  alias TheRushWeb.HomeLive

  defp sort_link(
         socket,
         text,
         sort_by,
         current_sort_by,
         current_sort_order,
         current_page,
         current_per_page
       ) do
    text =
      if sort_by == current_sort_by do
        raw(text <> sort_icon(current_sort_order))
      else
        text
      end

    live_patch(text,
      to:
        Routes.live_path(
          socket,
          HomeLive,
          sort_by: sort_by,
          sort_order: maybe_toggle_sort_order(sort_by, current_sort_by, current_sort_order),
          page: current_page,
          per_page: current_per_page
        )
    )
  end

  defp maybe_toggle_sort_order(sort_by, current_sort_by, current_sort_order)
       when sort_by == current_sort_by,
       do: toggle_sort_order(current_sort_order)

  defp maybe_toggle_sort_order(_, _, _), do: :asc

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

  defp concatenations(entry, %{concatenate_with: concatenations}) when is_list(concatenations) do
    Enum.reduce(concatenations, "", fn {field, label}, text ->
      text <> ((Map.get(entry, field) && label) || "")
    end)
  end

  defp concatenations(_, _), do: ""
end
