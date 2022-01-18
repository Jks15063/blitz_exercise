# BlitzExercise

To setup the project:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Export your API key in the terminal: `export API_KEY=<your riot API key>`
  * Start the project: `iex -S mix phx.server`

To start watching a summoner:
Visit: `http://localhost:4000/api/matches/summoner/champions/<summoner_name>?region=<region>`
It will return a JSON response containing the names of the champions played in the last five matches.  These names will be printed out to the terminal as well.  Hitting this route will also start a process that will check for new matches once a minute and stop after an hour.  Multiple summoners can be watched at the same time.
