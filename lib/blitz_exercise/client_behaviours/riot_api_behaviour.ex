defmodule BlitzExercise.RiotApiBehaviour do
  @callback fetch_summoner(String.t()) :: {:ok, response :: map} | {:error, reason :: term}
end
