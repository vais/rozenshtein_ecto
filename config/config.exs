import Config

config :rozenshtein_ecto, RozenshteinEcto.Repo,
  hostname: "localhost",
  database: "rozenshtein_ecto",
  username: "postgres",
  password: "postgres"

config :rozenshtein_ecto, ecto_repos: [RozenshteinEcto.Repo]
