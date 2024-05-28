defmodule RozenshteinEcto.Repo.Migrations.AddProfessorsTable do
  use Ecto.Migration

  def change do
    create table(:professors, primary_key: false) do
      add :fname, :string, primary_key: true
      add :lname, :string, primary_key: true
    end
  end
end
