defmodule BlitzExercise.Genservers.RiotProfileWatcher do
  use GenServer, restart: :transient

  alias BlitzExercise.ApiClients.RiotApiClient

  @registry BlitzExercise.Registry
  @supervisor BlitzExercise.SummonerSupervisor

  @refresh_time 60 * 1000
  @watch_time 60 * 60 * 1000

  def init({puuid, region}) do
    [latest_match_id] = RiotApiClient.fetch_match_list(puuid, region, 1)
    Process.send_after(self(), :watcher_timeout, @watch_time)
    check_for_new_match()

    {:ok, {puuid, region, latest_match_id}}
  end

  def handle_info(:check_for_new_match, {puuid, region, latest_match_id}) do
    [new_match_id] = RiotApiClient.fetch_match_list(puuid, region, 1)

    if new_match_id != latest_match_id do
      IO.puts("Summoner #{puuid} played a new match: #{new_match_id}")
    end

    check_for_new_match()
    {:noreply, {puuid, region, new_match_id}}
  end

  def handle_info(:watcher_timeout, {puuid, _, _} = state) do
    IO.puts("Killing watcher for summoner: #{puuid}")
    {:stop, :shutdown, state}
  end

  def start_link({puuid, region}) do
    GenServer.start_link(__MODULE__, {puuid, region}, name: process_name(puuid))
  end

  def watch_summoner(puuid, region) do
    DynamicSupervisor.start_child(@supervisor, {__MODULE__, {puuid, region}})

    puuid
  end

  defp process_name(puuid),
    do: {:via, Registry, {@registry, "summoner_#{puuid}"}}

  defp check_for_new_match() do
    Process.send_after(self(), :check_for_new_match, @refresh_time)
  end
end
