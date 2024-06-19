defmodule E12Test do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert_all("students", [
      [sno: "S1", age: 3],
      [sno: "S2", age: 2],
      [sno: "S3", age: 2],
      [sno: "S4", age: 4]
    ])

    %{expected: ["S2", "S3"]}
  end

  describe "E12 - Who are the youngest students?" do
    test "query", %{expected: expected} do
      all_ages_except_the_smallest_one =
        from s1 in "students",
          cross_join: s2 in "students",
          where: s1.age > s2.age,
          select: s1.age

      the_youngest_students =
        from s in "students",
          where: s.age not in subquery(all_ages_except_the_smallest_one),
          select: s.sno,
          order_by: s.sno

      assert Repo.all(the_youngest_students) == expected
    end

    test "using aggregation", %{expected: expected} do
      query =
        from s in "students",
          where: s.age == subquery(from s in "students", select: min(s.age)),
          select: s.sno,
          order_by: s.sno

      assert Repo.all(query) == expected
    end
  end
end
