# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankingApi.Repo.insert!(%BankingApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

[
  %{user: "Lynn"},
  %{user: "Jenny B"},
  %{user: "Jenny C"},
  %{user: "Markov"}
]
|> Enum.each(&BankingApi.Account.create/1)
