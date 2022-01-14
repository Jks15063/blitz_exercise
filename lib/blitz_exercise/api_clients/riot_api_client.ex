defmodule BlitzExercise.ApiClients.RiotApiClient do
  @behaviour BlitzExercise.RiotApiBehaviour

  @api_key Application.get_env(:blitz_exercise, :riot_api_key)

  @headers %{
    "Accept-Language" => "en-US,en;q=0.5",
    "Accept-Charset" => "application/x-www-form-urlencoded; charset=UTF-8",
    "Origin" => "https://developer.riotgames.com"
  }

  @impl BlitzExercise.RiotApiBehaviour
  def fetch_summoner(summoner_name, region \\ "na1") do
    url = "https://#{region}.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{summoner_name}"

    url
    |> HTTPoison.get(@headers, params: %{api_key: @api_key})
    |> handle_resp()
  end

  def fetch_match_list(puuid, region \\ "americas") do
    url = "https://#{region}.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids"
    params = %{start: 0, count: 5, api_key: @api_key}

    url
    |> HTTPoison.get(@headers, params: params)
    |> handle_resp()
  end

  def fetch_match_details(match_id, region \\ "americas") do
    url = "https://#{region}.api.riotgames.com/lol/match/v5/matches/#{match_id}"

    url
    |> HTTPoison.get(@headers, params: %{api_key: @api_key})
    |> handle_resp()
  end

  def fetch_summoner_champion_from_match(match_id, summoner_id, region \\ "americas") do
    match_id
    |> fetch_match_details()
    |> summoner_champion_name(summoner_id)
  end

  defp summoner_champion_name({:ok, %{"info" => %{"participants" => participants}}}, summoner_id) do
    participants
    |> Enum.find(fn participant -> participant["puuid"] == summoner_id end)
    |> Map.fetch!("championName")
  end

  defp handle_resp(resp) do
    case resp do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, Jason.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
