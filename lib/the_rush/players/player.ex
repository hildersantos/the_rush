defmodule TheRush.Players.Player do
  defstruct [
    player: "",
    team: "",
    position: "",
    attempts: 0,
    attempts_per_game: 0,
    yards_total: 0,
    yards_per_game: 0,
    touchdowns: 0,
    longest_rush: "",
    first_downs: 0,
    first_downs_percentage: 0,
    yards_20: 0,
    yards_40: 0,
    fumbles: 0
  ]

  alias __MODULE__

  import Norm
  import TheRush.Helpers

  require Logger

  @type t :: %__MODULE__{
    player: String.t(),
    team: String.t(),
    position: String.t(),
    attempts: integer(),
    attempts_per_game: float() | integer(),
    yards_total: integer(),
    yards_per_game: float() | integer(),
    touchdowns: integer(),
    longest_rush: map(),
    first_downs: integer(),
    first_downs_percentage: float() | integer(),
    yards_20: integer(),
    yards_40: integer(),
    fumbles: integer()
  }

  @doc """
  Schema for Player
  """
  def _s do
    schema(%{
      player: spec(is_binary()),
      team: spec(is_binary()),
      position: spec(is_binary()),
      attempts: spec(valid_integer?()),
      attempts_per_game: spec(is_float() or valid_integer?()),
      yards_total: spec(valid_integer?()),
      yards_per_game: spec(is_float() or valid_integer?()),
      touchdowns: spec(is_float() or valid_integer?()),
      longest_rush: schema(%{
        value: spec(is_integer()),
        touchdown: spec(is_boolean())
      }),
      first_downs: spec(valid_integer?()),
      first_downs_percentage: spec(is_float() or valid_integer?()),
      yards_20: spec(valid_integer?()),
      yards_40: spec(valid_integer?()),
      fumbles: spec(valid_integer?())
    })
  end

  @doc """
  Returns a new struct with optional params
  """
  @spec new(map()) :: Player.t()
  def new(params \\ %{}) do
    %Player{}
    |> Map.merge(params)
  end

  @doc """
  Validates a map against the expected schema contract.
  """
  @spec validate_input(any()) :: {:ok, map()} | {:error, String.t()} | {:error, [map()]}
  def validate_input(entry) when is_map(entry) do
    case conform(entry, _s()) do
      {:ok, _conformed} = valid_entry ->
        valid_entry
      {:error, conform_error} = error ->
        Logger.warn("TheRush.Players.Player.validate_input/1 received an invalid entry format #{inspect conform_error}")
        error
    end
  end

  def validate_input(entry) do
    Logger.warn("TheRush.Players.Player.validate_input/1 received invalid data: #{inspect entry}")
    {:error, "Invalid data"}
  end

end
