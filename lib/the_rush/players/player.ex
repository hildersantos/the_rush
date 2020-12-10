defmodule TheRush.Players.Player do
  @moduledoc """
  Player schema
  """
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  import TheRush.Helpers

  @all_fields ~w{
    name
    position
    team
    attempts
    attempts_per_game
    rushing_average
    yards_total
    yards_per_game
    touchdowns
    longest_rush_value
    longest_rush_touchdown
    first_downs
    first_downs_percentage
    yards_20
    yards_40
    fumbles
  }a

  schema "players" do
    field :name, :string
    field :position, :string
    field :team, :string
    field :attempts, :integer
    field :attempts_per_game, :float
    field :rushing_average, :float
    field :yards_total, :integer
    field :yards_per_game, :float
    field :touchdowns, :integer
    field :longest_rush_value, :integer
    field :longest_rush_touchdown, :boolean
    field :first_downs, :integer
    field :first_downs_percentage, :float
    field :yards_20, :integer
    field :yards_40, :integer
    field :fumbles, :integer

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, @all_fields)
    |> validate_required(@all_fields)
  end

  @doc false
  def sort(query, sort_by, sort_order \\ :asc) do
    from q in query,
      order_by: [{^sort_order, ^sort_by}]
  end

  @doc false
  def paginate(query, page \\ 0, per_page \\ 30) do
    from q in query,
      offset: ^((page - 1) * per_page),
      limit: ^per_page
  end
end
