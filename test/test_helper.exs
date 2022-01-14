ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BlitzExercise.Repo, :manual)

Mox.defmock(BlitzExercise.Genservers.RiotProfileWatcherMock,
  for: BlitzExercise.Genservers.RiotProfileWatcher
)
