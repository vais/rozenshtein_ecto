defmodule RozenshteinEcto.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students, primary_key: false) do
      add :sno, :string, primary_key: true
      add :name, :string
      add :age, :integer
    end
  end
end
