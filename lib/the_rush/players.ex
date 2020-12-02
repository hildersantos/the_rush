defmodule TheRush.Players do
  @moduledoc """
  This module interacts with players entries to provide all necessary operations.
  """

  alias TheRush.Players.Player

  import TheRush.Helpers, only: [convert_longest_rush: 1]

  @json_file "rushing.json"

  def create(params \\ %{}) do
    case Player.validate_input(params) do
      {:ok, valid_entry} ->
        {:ok, Player.new(valid_entry)}
      {:error, _} = error ->
        error
    end
  end

  def build_list do
    fetch_json()
    |> extract_from_json()
    |> validate_entries()
    |> Enum.reject(&(&1 == %{}))
  end

  def extract_from_json(json_entries) when is_list(json_entries) do
    Enum.map(json_entries, &extract_from_json/1)
  end

  def extract_from_json(json_entry) do
    %{
      player: json_entry["Player"],
      team: json_entry["Team"],
      position: json_entry["Pos"],
      attempts: json_entry["Att"],
      attempts_per_game: json_entry["Att/G"],
      yards_total: json_entry["Yds"],
      yards_per_game: json_entry["Avg"],
      touchdowns: json_entry["TD"],
      longest_rush: convert_longest_rush(json_entry["Lng"]),
      first_downs: json_entry["1st"],
      first_downs_percentage: json_entry["1st%"],
      yards_20: json_entry["20+"],
      yards_40: json_entry["40+"],
      fumbles: json_entry["FUM"],
    }
  end

  defp fetch_json() do
    files().fetch_json(@json_file)
  end

  defp validate_entries(entries) do
    Enum.map(entries, fn entry ->
      case create(entry) do
        {:ok, %Player{} = player} ->
          player
        {:error, _} ->
          %{} 
      end
    end)
  end

  defp files do
    Application.get_env(:the_rush, :files_module, TheRush.Files)
  end
end
