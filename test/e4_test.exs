defmodule E4Test do
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
      [sno: "S1", cno: "CS114"],
      [sno: "S2", cno: "CS111"],
      [sno: "S3", cno: "CS112"],
      [sno: "S4", cno: "CS114"]
    ])

    %{expected: ["S1"]}
  end

  describe "E4 - Who takes both CS112 and CS114?" do
    test "using a self join", %{expected: expected} do
      query =
        from t1 in "takes",
          join: t2 in "takes",
          on: t1.sno == t2.sno,
          where: t1.cno == "CS112" and t2.cno == "CS114",
          select: t1.sno

      assert Repo.all(query) == expected
    end
  end
end
