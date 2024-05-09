import Config

config :rozenshtein_ecto, RozenshteinEcto.Repo,
  hostname: "localhost",
  database: "rozenshtein_ecto",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :rozenshtein_ecto, ecto_repos: [RozenshteinEcto.Repo]
