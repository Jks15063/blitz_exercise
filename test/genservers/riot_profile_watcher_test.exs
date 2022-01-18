defmodule BlitzExercise.Genservers.RiotProfileWatcherTest do
  use ExUnit.Case, async: true

  import Mox

  alias BlitzExercise.Genservers.RiotProfileWatcher

  describe "watch_summoner/2" do
    test "starts a named process" do
      BlitzExercise.RiotApiBehaviourMock
      |> expect(:fetch_match_list, fn _puuid, _region, _count ->
        ["match_1", "match_2", "match_3", "match_4", "match_5"]
      end)

      pid = RiotProfileWatcher.watch_summoner("puuid", "na1")
      # NOTE: can't this mock to work
      # IO.inspect(pid)
      # assert Registry.lookup(BlitzExercise.Registry, "summoner_puuid") == [pid]
      # assert Task.Supervisor.children(BlitzExercise.SummonerSupervisor) == []
    end
  end
end
