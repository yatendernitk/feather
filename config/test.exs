use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :feather, FeatherWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :feather, Feather.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "ok",
  password: "maxx",
  database: "feather_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  types: Feather.PostgresTypes
