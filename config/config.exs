# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blitz_exercise,
  ecto_repos: [BlitzExercise.Repo]

# Configures the endpoint
config :blitz_exercise, BlitzExerciseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FoV+aycvSaQsTMfCaZEIra55hULYwOaB03AhLzfQBvJkqUb4/VF11UiVaF+2xiKy",
  render_errors: [view: BlitzExerciseWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BlitzExercise.PubSub,
  live_view: [signing_salt: "4jjLADRX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
