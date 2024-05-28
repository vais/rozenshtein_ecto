defmodule E7Test do
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

    %{expected: ["S3", "S1"]}
  end

  describe "E7 - Who takes at least 2 courses?" do
    test "query", %{expected: expected} do
      query =
        from t1 in "take",
          join: t2 in "take",
          on: t1.sno == t2.sno,
          where: t1.cno != t2.cno,
          select: t1.sno,
          distinct: true,
          order_by: [desc: t1.sno]

      assert Repo.all(query) == expected
    end
  end
end
