use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :phoenix_aptlist, PhoenixAptlistWeb.Endpoint,
  secret_key_base: "j0zye/FOV374H8yxjcAxBh09jZmj6dOCKr2rMmwLUWmB/3FpOLQzOoq7Ze9j/H/0"

# Configure your database
config :phoenix_aptlist, PhoenixAptlist.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_aptlist_prod",
  pool_size: 15
