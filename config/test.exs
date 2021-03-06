use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :william_storck_phx, WilliamStorckPhxWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :william_storck_phx, WilliamStorckPhx.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "william_storck_phx_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, :log_rounds, 4

System.put_env("HASHID_SALT", "too salty for me")
