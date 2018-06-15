# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :william_storck_phx,
  ecto_repos: [WilliamStorckPhx.Repo]

# Configures the endpoint
config :william_storck_phx, WilliamStorckPhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2zQH2NgsFe631lmQX4G5a7RpV9v1uh8gcBw/IRbWMKnuABfj4uooqnafd+5Hdgj4",
  render_errors: [view: WilliamStorckPhxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WilliamStorckPhx.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
