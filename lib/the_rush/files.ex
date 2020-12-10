defmodule TheRush.Files do
  @moduledoc """
  Reads file and returns JSON struct
  """

  @callback fetch_json(String.t()) :: [map()]

  @doc """
  Handles JSON files
  """
  def fetch_json(filename) do
    path = "#{File.cwd!()}/priv/support_files/#{filename}"

    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.join("")
    |> Jason.decode!()
  end
end
