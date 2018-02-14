# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Auth.Repo.insert!(%Auth.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, _user} = Auth.Accounts.create_user(%{
  username: "writer",
  password: "qweqweqwe",
  permissions: %{default: [:read_users, :write_users]}
})

{:ok, _user} = Auth.Accounts.create_user(%{
  username: "reader",
  password: "qweqweqwe",
  permissions: %{default: [:read_users]}
})

{:ok, _user} = Auth.Accounts.create_user(%{
  username: "rubbish",
  password: "qweqweqwe",
  permissions: %{default: []}
})
