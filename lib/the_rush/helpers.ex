defmodule TheRush.Helpers do
  @moduledoc """
  Functions for supporting the application
  """

  def valid_integer?(input) do
    convert_to_integer(input) && true || false
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

end
