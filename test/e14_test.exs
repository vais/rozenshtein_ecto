defmodule E14Test do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert_all("professors", [
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
    ])

    %{
      expected: [
        ["D1", 2.5],
        ["D2", 6.5]
      ]
    }
  end

  describe """
  E14 - For each department that has
  more than 3 professors older than 50,
  what is the average salary of such professors?
  """ do
    test "query", %{expected: expected} do
      query =
        from p in "professors",
          where: p.age > 50,
          group_by: p.dept,
          having: count() > 3,
          select: [p.dept, type(avg(p.salary), :float)],
          order_by: p.dept

      assert Repo.all(query) == expected
    end
  end
end
