defmodule BlitzExercise.Genservers.RiotProfileWatcher do
  use GenServer
  require Logger

  # @refresh_time 1 * 60 * 1000
  @refresh_time 5 * 1000

  def init(state) do
    refresh_state()
    {:ok, state}
  end

  def handle_info(:refresh_state, state) do
    refresh_state()
    {:noreply, state}
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Client functions

  def subscribe(profile_id) do
    Phoenix.PubSub.subscribe(BlitzExercise.PubSub, "profile-#{profile_id}")
  end

  defp refresh_state() do
    Process.send_after(self(), :refresh_state, @refresh_time)
  end
end
