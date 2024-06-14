defmodule E18Test do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert_all("professors", [
      [fname: "F01", lname: "L01", dept: "D1", salary: 1],
      [fname: "F02", lname: "L02", dept: "D1", salary: 2],
      [fname: "F03", lname: "L03", dept: "D1", salary: 3],
      [fname: "F04", lname: "L04", dept: "D1", salary: 4],
      [fname: "F05", lname: "L05", dept: "D1", salary: 5],
      [fname: "F06", lname: "L06", dept: "D2", salary: 6],
      [fname: "F07", lname: "L07", dept: "D2", salary: 7],
      [fname: "F08", lname: "L08", dept: "D2", salary: 8],
      [fname: "F09", lname: "L09", dept: "D2", salary: 9],
      [fname: "F10", lname: "L10", dept: "D2", salary: 10]
    ])

    %{
      expected: [
        ["F04", "L04"],
        ["F05", "L05"],
        ["F09", "L09"],
        ["F10", "L10"]
      ]
    }
  end

  describe "E18 - Whose salary is greater than the average salary within that professor's department?" do
    test "using a self-join with GROUP BY and HAVING clauses", %{expected: expected} do
      query =
        from p1 in "professors",
          join: p2 in "professors",
          on: p1.dept == p2.dept,
          group_by: [p1.dept, p1.fname, p1.lname],
          having: p1.salary > avg(p2.salary),
          select: [p1.fname, p1.lname],
          order_by: [p1.fname, p1.lname]

      assert Repo.all(query) == expected
    end

    test "using a join to an aggregated query", %{expected: expected} do
      avg_salary_by_department =
        from p in "professors",
          select: %{dept: p.dept, salary: avg(p.salary)},
          group_by: p.dept

      query =
        from p in "professors",
          join: s in subquery(avg_salary_by_department),
          on: p.dept == s.dept,
          where: p.salary > s.salary,
          select: [p.fname, p.lname],
          order_by: [p.fname, p.lname]

      assert Repo.all(query) == expected
    end
  end
end
