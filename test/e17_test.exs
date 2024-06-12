defmodule E17Test do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert_all("professors", [
      [fname: "F01", lname: "L01", salary: 1],
      [fname: "F02", lname: "L02", salary: 2],
      [fname: "F03", lname: "L03", salary: 3],
      [fname: "F04", lname: "L04", salary: 4],
      [fname: "F05", lname: "L05", salary: 5]
    ])

    %{
      expected: [
        "F05 L05",
        "F04 L04"
      ]
    }
  end

  defmacro fullname(t) do
    quote do
      fragment("concat(?, ' ', ?)", unquote(t).fname, unquote(t).lname)
    end
  end

  describe "E17 - Whose salary is greater than the overall average salary?" do
    test "using a CROSS JOIN with GROUP BY and HAVING clauses", %{expected: expected} do
      query =
        from p1 in "professors",
          cross_join: p2 in "professors",
          select: fullname(p1),
          group_by: [fullname(p1), p1.salary],
          having: p1.salary > avg(p2.salary),
          order_by: [desc: fullname(p1)]

      assert Repo.all(query) == expected
    end

    test "using a global aggregate subquery (more sane?)", %{expected: expected} do
      overall_average_salary =
        from p in "professors", select: avg(p.salary)

      query =
        from p in "professors",
          where: p.salary > subquery(overall_average_salary),
          select: fullname(p),
          order_by: [desc: fullname(p)]

      assert Repo.all(query) == expected
    end
  end
end
