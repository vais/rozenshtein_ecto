defmodule RozenshteinEcto.Repo.Migrations.CreateTakes do
  use Ecto.Migration

  def change do
    create table(:takes, primary_key: false) do
      add :sno, references(:students, column: :sno, type: :string), primary_key: true
      add :cno, :string, primary_key: true
      add :grade, :integer
    end
  end
end
