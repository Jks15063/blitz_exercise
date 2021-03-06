defmodule BlitzExerciseWeb.Api.MatchController do
  use BlitzExerciseWeb, :controller

  alias BlitzExercise.Genservers.RiotProfileWatcher

  @match_region_map %{
    "br1" => "americas",
    "la1" => "americas",
    "la2" => "americas",
    "oc1" => "americas",
    "na1" => "americas",
    "kr" => "asia",
    "jp" => "asia",
    "eun1" => "europe",
    "euw1" => "europe",
    "ru" => "europe",
    "tr1" => "europe"
  }

  def show(conn, %{"region" => region, "summoner_name" => summoner_name}) do
    puuid = api_client().fetch_summoner_puuid(summoner_name, region)

    champion_list =
      api_client().fetch_last_five_champions_played(puuid, @match_region_map[region])

    RiotProfileWatcher.watch_summoner(puuid, @match_region_map[region])

    IO.inspect(champion_list, label: "Last 5 champions played")
    json(conn, %{data: champion_list})
  end

  defp api_client, do: Application.get_env(:blitz_exercise, :api_client)
end
