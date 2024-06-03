defmodule RozenshteinEcto.Repo.Migrations.AddDeptAgeSalaryToProfessors do
  use Ecto.Migration

  def change do
    alter table(:professors) do
      add :dept, :string
      add :salary, :integer
      add :age, :integer
    end
  end
end
