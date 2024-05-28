defmodule RozenshteinEcto.Repo.Migrations.AddTeachTable do
  use Ecto.Migration

  def change do
    create table(:teach, primary_key: false) do
      add :fname, :string, primary_key: true
      add :lname, :string, primary_key: true
      add :cno, :string, primary_key: true
    end
  end
end
