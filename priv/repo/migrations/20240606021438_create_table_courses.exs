defmodule RozenshteinEcto.Repo.Migrations.CreateTableCourses do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add :cno, :string, primary_key: true
      add :title, :string
      add :credits, :integer
    end
  end
end
