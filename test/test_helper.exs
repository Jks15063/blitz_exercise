ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BlitzExercise.Repo, :manual)

Mox.defmock(BlitzExercise.RiotApiBehaviourMock,
  for: BlitzExercise.RiotApiBehaviour
)
