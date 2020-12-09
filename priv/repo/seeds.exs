# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TheRush.Repo.insert!(%TheRush.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TheRush.Players
alias TheRush.Players.Player
alias TheRush.Repo

Repo.delete_all(Player)

Players.build_list()
|> Enum.each(fn params ->
  struct(Player, params)
  |> Repo.insert!()
end)
