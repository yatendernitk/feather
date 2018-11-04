ExUnit.start()

Mix.Task.run "ecto.create", ~w(-r Feather.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Feather.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(Feather.Repo, {:shared, self()})

