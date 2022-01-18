import Config

config :blitz_exercise, api_client: BlitzExercise.RiotApiBehaviourMock

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :blitz_exercise, BlitzExercise.Repo,
  username: "postgres",
  password: "postgres",
  database: "blitz_exercise_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blitz_exercise, BlitzExerciseWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
