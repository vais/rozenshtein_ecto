defmodule E11Test do
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

    Repo.insert_all("takes", [
      [sno: "S1", cno: "CS112"],
      [sno: "S1", cno: "CS113"],
      [sno: "S2", cno: "CS114"],
      [sno: "S3", cno: "CS111"],
      [sno: "S3", cno: "CS112"],
      [sno: "S3", cno: "CS113"],
      [sno: "S3", cno: "CS114"]
    ])

    %{expected: ["S2", "S1"]}
  end

  describe "E11 - Who takes either CS112 or CS114 but not both?" do
    test "query", %{expected: expected} do
      query =
        from t in "takes",
          where: t.cno in ~w(CS112 CS114),
          where:
            t.sno not in subquery(
              from t1 in "takes",
                join: t2 in "takes",
                on: t1.sno == t2.sno,
                where: t1.cno == "CS112",
                where: t2.cno == "CS114",
                select: t1.sno
            ),
          select: t.sno,
          order_by: [desc: t.sno]

      assert Repo.all(query) == expected
    end
  end
end
