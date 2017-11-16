# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_aptlist,
  ecto_repos: [PhoenixAptlist.Repo]

# Configures the endpoint
config :phoenix_aptlist, PhoenixAptlistWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t1rL1F1Ypx2gPv69LWlv4ys+EN9xBg5GnaDOHbO46FTUEFiCJh01eaUfQ8lRQbbd",
  render_errors: [view: PhoenixAptlistWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PhoenixAptlist.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
