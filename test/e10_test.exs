defmodule E10Test do
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
      [sno: "S2", cno: "CS112"],
      [sno: "S3", cno: "CS111"],
      [sno: "S3", cno: "CS112"],
      [sno: "S3", cno: "CS113"]
    ])

    %{expected: ["S2"]}
  end

  describe "E10 - Who takes only CS112?" do
    test "query", %{expected: expected} do
      takes_CS112 =
        from t in "takes",
          where: t.cno == "CS112",
          select: t.sno

      takes_other_courses =
        from t in "takes",
          where: t.cno != "CS112",
          select: t.sno

      takes_only_CS112 =
        from t in takes_CS112,
          where: t.sno not in subquery(takes_other_courses)

      assert Repo.all(takes_only_CS112) == expected
    end
  end
end
