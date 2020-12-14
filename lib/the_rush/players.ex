defmodule TheRush.Players do
  @moduledoc """
  This module is responsible for interacting with Player records.
  """
  @json_file "rushing.json"

  alias TheRush.Players.Player
  alias TheRush.Repo

  import TheRush.Helpers,
    only: [convert_longest_rush: 1, convert_to_integer: 1, convert_to_float: 1]

  @doc """
  Creates a new player.
  """
  def create(params) do
    %Player{}
    |> Player.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Get players sorted and/or paginated
  """
  def all(criteria) do
    Player
    |> build_query(criteria)
    |> Repo.all()
  end

  @doc """
  Returns the total number of player entries.
  """
  def total_count do
    Player
    |> count_results()
    |> Repo.one()
  end

  def total_count(criteria) do
    Player
    |> build_query(criteria)
    |> count_results()
    |> Repo.one()
  end

  @doc """
  Build the initial list of players based in a JSON file.
  """
  def build_list do
    fetch_json()
    |> extract_from_json()
    |> Enum.reject(&(&1 == %{}))
  end

  defp build_query(query, criteria) do
    Enum.reduce(criteria, query, fn
      {:pagination, %{page: page, per_page: per_page}}, query ->
        Player.paginate(query, page, per_page)

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        Player.sort(query, sort_by, sort_order)

      {:filter_by_name, nil}, query ->
        query

      {:filter_by_name, ""}, query ->
        query

      {:filter_by_name, search_query}, query ->
        Player.filter_by_name(query, search_query)
    end)
  end

  defp count_results(query) do
    Player.count(query)
  end

  defp fetch_json do
    files().fetch_json(@json_file)
  end

  defp extract_from_json(json_entries) when is_list(json_entries) do
    Enum.map(json_entries, &extract_from_json/1)
  end

  defp extract_from_json(json_entry) do
    longest_rush = convert_longest_rush(json_entry["Lng"])

    %{
      name: json_entry["Player"],
      team: json_entry["Team"],
      position: json_entry["Pos"],
      attempts: json_entry["Att"],
      attempts_per_game: convert_to_float(json_entry["Att/G"]),
      rushing_average: convert_to_float(json_entry["Avg"]),
      yards_total: convert_to_integer(json_entry["Yds"]),
      yards_per_game: convert_to_float(json_entry["Yds/G"]),
      touchdowns: json_entry["TD"],
      longest_rush_value: longest_rush.value,
      longest_rush_touchdown: longest_rush.touchdown,
      first_downs: json_entry["1st"],
      first_downs_percentage: convert_to_float(json_entry["1st%"]),
      yards_20: convert_to_integer(json_entry["20+"]),
      yards_40: convert_to_integer(json_entry["40+"]),
      fumbles: convert_to_integer(json_entry["FUM"])
    }
  end

  defp files do
    Application.get_env(:the_rush, :files_module, TheRush.Files)
  end
end
