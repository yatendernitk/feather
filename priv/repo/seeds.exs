# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Feather.Repo.insert!(%Feather.SomeSchema{})
#
# item = %{code: "DELHI", description: "testing code", is_active: true, type: "unique", amount: 101.50, event_location: %Geo.Point{coordinates: {77.1025, 28.7041}, srid: 4326}}
# item = %{code: "KHURJA", description: "testing code", is_active: true, type: "unique", amount: 101.50, event_location: %Geo.Point{coordinates: {77.8539, 28.2514}, srid: 4326}}
# item = %{code: "MEERUT", description: "testing code", is_active: true, type: "unique", amount: 101.50, event_location: %Geo.Point{coordinates: {77.7064, 28.9845}, srid: 4326}}
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
