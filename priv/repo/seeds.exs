# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Feelbot.Repo.insert!(%Feelbot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Accounts
alias Feelbot.Accounts
Accounts.create_user(%{username: "bijanbwb", display_name: "Bijan", avatar: "https://avatars2.githubusercontent.com/u/201320"})
