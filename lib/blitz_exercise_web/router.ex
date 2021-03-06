defmodule BlitzExerciseWeb.Router do
  use BlitzExerciseWeb, :router
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BlitzExerciseWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlitzExerciseWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", BlitzExerciseWeb.Api, as: :api do
    pipe_through :api

    resources "/matches/summoner/champions", MatchController,
      only: [:show],
      param: "summoner_name"
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BlitzExerciseWeb.Telemetry
    end
  end

  def handle_errors(conn, %{
        kind: _kind,
        reason: %{value: {"status", %{"message" => message, "status_code" => status_code}}},
        stack: _stack
      }) do
    send_resp(conn, status_code, "Error: #{status_code}, #{message}")
  end
end
