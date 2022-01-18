defmodule BlitzExerciseWeb.Api.MatchController do
  use BlitzExerciseWeb, :controller

  alias BlitzExercise.ApiClients.RiotApiClient
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
    champion_list =
      summoner_name
      |> RiotApiClient.fetch_summoner_puuid(region)
      |> RiotProfileWatcher.watch_summoner(@match_region_map[region])
      |> RiotApiClient.fetch_last_five_champions_played(@match_region_map[region])

    IO.inspect(champion_list, label: "Last 5 champions played")
    json(conn, %{data: champion_list})
  end
end
