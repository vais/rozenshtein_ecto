defmodule E3Test do
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
      [sno: "S1", cno: "CS114"],
      [sno: "S2", cno: "CS111"],
      [sno: "S3", cno: "CS112"],
      [sno: "S4", cno: "CS114"]
    ])

    %{expected: ["S4", "S3", "S1"]}
  end

  describe "E3 - Who takes CS112 or CS114?" do
    test "using the OR operator", %{expected: expected} do
      query =
        from take in "take",
          where: take.cno == "CS112" or take.cno == "CS114",
          select: take.sno,
          order_by: [desc: take.sno],
          distinct: true

      assert Repo.all(query) == expected
    end

    test "using the IN operator", %{expected: expected} do
      query =
        from take in "take",
          where: take.cno in ["CS112", "CS114"],
          select: take.sno,
          order_by: [desc: take.sno],
          distinct: true

      assert Repo.all(query) == expected
    end

    test "using or_where query expression", %{expected: expected} do
      query =
        from take in "take",
          where: take.cno == "CS112",
          or_where: take.cno == "CS114",
          select: take.sno,
          order_by: [desc: take.sno],
          distinct: true

      assert Repo.all(query) == expected
    end
  end
end
