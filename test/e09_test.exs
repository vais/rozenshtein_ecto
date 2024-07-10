defmodule E9Test do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert_all("students", [
      [sno: "S1"],
      [sno: "S2"],
      [sno: "S3"],
      [sno: "S4"]
    ])

    Repo.insert_all("take", [
      [sno: "S1", cno: "CS112"],
      [sno: "S1", cno: "CS113"],
      [sno: "S2", cno: "CS112"],
      [sno: "S3", cno: "CS111"],
      [sno: "S3", cno: "CS112"],
      [sno: "S3", cno: "CS113"]
    ])

    %{expected: ["S1"]}
  end

  describe "E9 - Who takes exactly 2 courses?" do
    test "using a Type 2 query", %{expected: expected} do
      who_takes_at_least_2 =
        from t1 in "take",
          join: t2 in "take",
          on: t2.sno == t1.sno,
          where: t2.cno != t1.cno

      who_takes_at_least_3 =
        from t1 in "take",
          join: t2 in "take",
          on: t2.sno == t1.sno,
          join: t3 in "take",
          on: t3.sno == t1.sno,
          where: t3.cno != t1.cno,
          where: t2.cno != t1.cno,
          where: t2.cno != t3.cno

      who_takes_exactly_2 =
        from t in who_takes_at_least_2,
          where:
            t.sno not in subquery(
              from t in who_takes_at_least_3,
                select: t.sno
            ),
          select: t.sno,
          order_by: [desc: t.sno],
          distinct: true

      assert Repo.all(who_takes_exactly_2) == expected
    end

    test "using aggregation", %{expected: expected} do
      query =
        from t in "take",
          group_by: t.sno,
          having: count() == 2,
          select: t.sno

      assert Repo.all(query) == expected
    end

    test "using a type 3 query", %{expected: expected} do
      query =
        from t1 in "take",
          as: :t1,
          join: t2 in "take",
          as: :t2,
          on: t1.sno == t2.sno,
          where:
            t1.cno < t2.cno and
              not exists(
                from t in "take",
                  where:
                    t.sno == parent_as(:t1).sno and
                      t.cno != parent_as(:t1).cno and
                      t.cno != parent_as(:t2).cno,
                  select: 1
              ),
          select: t1.sno

      assert Repo.all(query) == expected
    end
  end
end
