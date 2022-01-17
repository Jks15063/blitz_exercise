defmodule BlitzExercise.RiotApiBehaviour do
  @callback fetch_summoner_puuid(String.t(), String.t()) ::
              {:ok, response :: map} | {:error, reason :: term}
end
