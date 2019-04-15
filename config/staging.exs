use Mix.Config

config :william_storck_phx, WilliamStorckPhxWeb.Endpoint,
  http: [port: System.get_env("PORT")],
  url: [scheme: "https", host: "storck-staging", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :william_storck_phx, WilliamStorckPhx.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  database: System.get_env("DATABASE_NAME"),
  pool_size: System.get_env("POOL_SIZE")

config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), :instance_role]

config :sendgrid,
  api_key: System.get_env("SENDGRID_API_KEY")
