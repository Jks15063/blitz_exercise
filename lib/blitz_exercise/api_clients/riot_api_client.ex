defmodule BlitzExercise.ApiClients.RiotApiClient do
  @behaviour BlitzExercise.RiotApiBehaviour
  @api_key Application.get_env(:blitz_exercise, :riot_api_key)
  @headers %{
    "Accept-Language" => "en-US,en;q=0.5",
    "Accept-Charset" => "application/x-www-form-urlencoded; charset=UTF-8",
    "Origin" => "https://developer.riotgames.com"
  }

  @impl BlitzExercise.RiotApiBehaviour
  def fetch_summoner_puuid(summoner_name, region) do
    url = "https://#{region}.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{summoner_name}"

    url
    |> HTTPoison.get!(@headers, params: %{api_key: @api_key})
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("puuid")
  end

  @impl BlitzExercise.RiotApiBehaviour
  def fetch_match_list(puuid, region, count \\ 5) do
    url = "https://#{region}.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids"
    params = %{start: 0, count: count, api_key: @api_key}

    resp = HTTPoison.get!(url, @headers, params: params)
    Jason.decode!(resp.body)
  end

  @impl BlitzExercise.RiotApiBehaviour
  def fetch_last_five_champions_played(puuid, region) do
    puuid
    |> fetch_match_list(region)
    |> Enum.map(&fetch_match_details(&1, region))
    |> Enum.map(&summoner_champion_name(&1, puuid))
  end

  defp fetch_match_details(match_id, region) do
    url = "https://#{region}.api.riotgames.com/lol/match/v5/matches/#{match_id}"

    resp = HTTPoison.get!(url, @headers, params: %{api_key: @api_key})
    Jason.decode!(resp.body)
  end

  defp summoner_champion_name(%{"info" => %{"participants" => participants}}, puuid) do
    participants
    |> Enum.find(fn participant -> participant["puuid"] == puuid end)
    |> Map.fetch!("championName")
  end
end
