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

BankingApi.Repo.insert!(%BankingApi.Account.create({
  user: "Lynn"
})

BankingApi.Repo.insert!(%BankingApi.Account.create({
  user: "Jenny B"
})

BankingApi.Repo.insert!(%BankingApi.Account.create({
  user: "Jenny C"
})

BankingApi.Repo.insert!(%BankingApi.Account.create({
  user: "Markov"
})
