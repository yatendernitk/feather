# Feather

To Setup Database
  * install Postgres and activate PostGIS
  * update your username & password in config/prod.exs & config/dev.exs

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  <!-- * Create and migrate your database with `mix ecto.create && mix ecto.migrate` -->
  * create & setup your db with `mix ecto.setup`
  <!-- * Install Node.js dependencies with `cd assets && npm install` -->
  * Start Phoenix endpoint with `iex -S mix phx.server`

Checkout wiki page in github for information about how to use APIs

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


* To run this project in production env
 - Create a new file prod.secret.exs in config folder and give configuration of database like i have given in dev.exs then create db in prod and run the project with.

`MIX_ENV=prod iex -S mix phx.server`

## Learn more

  * for any query you can email me at yatener[dot]nitk[at]outlook[dot]com
  * suggestions are welcome

Thank You
Yatender