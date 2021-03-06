defmodule BlitzExerciseWeb.Api.MatchControllerTest do
  use BlitzExerciseWeb.ConnCase
  use ExUnit.Case, async: true

  import Mox
  import ExUnit.CaptureIO

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show" do
    test "returns a list of champion names", %{conn: conn} do
      BlitzExercise.RiotApiBehaviourMock
      |> expect(:fetch_summoner_puuid, fn _name, _region ->
        "puuid"
      end)

      BlitzExercise.RiotApiBehaviourMock
      |> expect(:fetch_match_list, fn _puuid, _region, _count ->
        ["match_1", "match_2", "match_3", "match_4", "match_5"]
      end)

      BlitzExercise.RiotApiBehaviourMock
      |> expect(:fetch_last_five_champions_played, fn _puuid, _region ->
        ["a", "b", "c", "d", "e"]
      end)

      assert capture_io(fn ->
               conn = get(conn, Routes.api_match_path(conn, :show, "test", region: "region"))
               assert ["a", "b", "c", "d", "e"] = json_response(conn, 200)["data"]
             end) == "Last 5 champions played: [\"a\", \"b\", \"c\", \"d\", \"e\"]\n"
    end
  end
end
