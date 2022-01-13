defmodule BlitzExercise.Repo do
  use Ecto.Repo,
    otp_app: :blitz_exercise,
    adapter: Ecto.Adapters.Postgres
end
