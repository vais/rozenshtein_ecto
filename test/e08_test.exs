defmodule E8Test do
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

    %{expected: ["S4", "S2", "S1"]}
  end

  describe "E8 - Who takes at most 2 courses?" do
    test "query", %{expected: expected} do
      who_takes_at_least_3 =
        from t1 in "take",
          join: t2 in "take",
          on: t2.sno == t1.sno,
          join: t3 in "take",
          on: t3.sno == t1.sno,
          where: t1.cno != t2.cno and t1.cno != t3.cno and t2.cno != t3.cno,
          select: t1.sno

      who_takes_at_most_2 =
        from s in "students",
          where: s.sno not in subquery(who_takes_at_least_3),
          order_by: [desc: s.sno],
          select: s.sno

      assert Repo.all(who_takes_at_most_2) == expected
    end
  end
end
