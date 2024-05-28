defmodule RozenshteinEcto.Repo.Migrations.RenameTakesTable do
  use Ecto.Migration

  def change do
    rename table(:takes), to: table(:take)
  end
end
