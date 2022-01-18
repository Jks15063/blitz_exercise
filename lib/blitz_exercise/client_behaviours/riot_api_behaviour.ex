defmodule BlitzExercise.RiotApiBehaviour do
  @callback fetch_summoner_puuid(String.t(), String.t()) :: String.t()
  @callback fetch_match_list(String.t(), String.t(), integer()) :: list(String.t())
  @callback fetch_last_five_champions_played(String.t(), String.t()) :: list(String.t())
end
