defmodule RozenshteinEcto.Repo do
  use Ecto.Repo,
    otp_app: :rozenshtein_ecto,
    adapter: Ecto.Adapters.Postgres
end
