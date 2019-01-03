use Mix.Config

config :william_storck_phx, WilliamStorckPhxWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :william_storck_phx, WilliamStorckPhxWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/william_storck_phx_web/views/.*(ex)$},
      ~r{lib/william_storck_phx_web/templates/.*(eex|slim|slime)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :william_storck_phx, WilliamStorckPhx.Repo,
  username: "postgres",
  password: "postgres",
  database: "william_storck_phx_dev",
  hostname: "localhost",
  pool_size: 10

System.put_env("HASHID_SALT", "too salty for me")
