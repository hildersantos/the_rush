defmodule TheRush.Helpers do
  @moduledoc """
  Functions for supporting the application
  """

  def valid_integer?(input) do
    (convert_to_integer(input) && true) || false
  end

  def convert_to_integer(input) when is_binary(input) do
    input = String.replace(input, ",", "")

    try do
      String.to_integer(input)
    rescue
      ArgumentError ->
        nil
    else
      integer ->
        integer
    end
  end

  def convert_to_integer(input) when is_integer(input), do: input
  def convert_to_integer(_), do: nil

  def convert_longest_rush(value) when is_binary(value) do
    converted =
      Regex.split(~r/T/, value,
        include_captures: true,
        trim: true
      )

    build_longest_rush_map(converted)
  end

  def convert_longest_rush(value) when is_integer(value) or is_float(value) do
    build_longest_rush_map([value])
  end

  def convert_longest_rush(_), do: nil

  def convert_to_float(number), do: number / 1

  defp build_longest_rush_map([value]) do
    %{
      value: convert_to_integer(value),
      touchdown: false
    }
  end

  defp build_longest_rush_map([value, "T"]) do
    %{
      value: convert_to_integer(value),
      touchdown: true
    }
  end

  defp build_longest_rush_map(_), do: nil
end
