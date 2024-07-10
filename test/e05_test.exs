defmodule E5Test do
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
      [sno: "S3", cno: "CS113"]
    ])

    %{expected: ["S3", "S4"]}
  end

  describe "E5 - Who does not take CS112?" do
    test "using a type 2 query with NOT IN", %{expected: expected} do
      who_takes =
        from t in "take",
          where: t.cno == "CS112",
          select: t.sno

      who_does_not_take =
        from s in "students",
          where: s.sno not in subquery(who_takes),
          select: s.sno

      actual = who_does_not_take |> Repo.all() |> Enum.sort()
      assert actual == expected
    end

    test "using a type 3 query with NOT EXISTS", %{expected: expected} do
      query =
        from s in "students",
          as: :student,
          where:
            not exists(
              from t in "take",
                where: t.sno == parent_as(:student).sno and t.cno == "CS112",
                select: 1
            ),
          select: s.sno,
          order_by: s.sno

      assert Repo.all_and_log(query) == expected
    end
  end
end
