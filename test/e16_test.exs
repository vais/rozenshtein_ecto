defmodule E16Test do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    professors = [
      [fname: "F01", lname: "L01", dept: "D1", salary: 1, age: 51],
      [fname: "F02", lname: "L02", dept: "D1", salary: 2, age: 52],
      [fname: "F03", lname: "L03", dept: "D1", salary: 3, age: 53],
      [fname: "F04", lname: "L04", dept: "D1", salary: 4, age: 54],
      [fname: "F05", lname: "L05", dept: "D1", salary: 5, age: 50],
      [fname: "F06", lname: "L06", dept: "D2", salary: 5, age: 51],
      [fname: "F07", lname: "L07", dept: "D2", salary: 6, age: 51],
      [fname: "F10", lname: "L10", dept: "D2", salary: 7, age: 51],
      [fname: "F11", lname: "L11", dept: "D2", salary: 8, age: 51],
      [fname: "F12", lname: "L12", dept: "D3", salary: 1, age: 51],
      [fname: "F13", lname: "L13", dept: "D3", salary: 2, age: 51],
      [fname: "F14", lname: "L14", dept: "D3", salary: 3, age: 51]
    ]

    Repo.insert_all("professors", professors)

    total_salary_of_professors_older_than_50 =
      professors
      |> Enum.filter(fn professor -> professor[:age] > 50 end)
      |> Enum.map(fn professor -> professor[:salary] end)
      |> Enum.sum()

    total_count_of_professors_older_than_50 =
      professors
      |> Enum.filter(fn professor -> professor[:age] > 50 end)
      |> Enum.count()

    %{
      expected: [
        total_salary_of_professors_older_than_50 / total_count_of_professors_older_than_50
      ]
    }
  end

  describe "E16 - What is the overall average salary of all professors who are older than 50?" do
    test "query", %{expected: expected} do
      query =
        from p in "professors",
          select: fragment("cast(? as float)", avg(p.salary)),
          where: p.age > 50

      assert Repo.all(query) == expected
    end
  end
end
