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

    Repo.insert_all("takes", [
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
        from takes in "takes",
          where: takes.cno == "CS112" or takes.cno == "CS114",
          select: takes.sno,
          order_by: [desc: takes.sno],
          distinct: true

      assert Repo.all(query) == expected
    end

    test "using the IN operator", %{expected: expected} do
      query =
        from takes in "takes",
          where: takes.cno in ["CS112", "CS114"],
          select: takes.sno,
          order_by: [desc: takes.sno],
          distinct: true

      assert Repo.all(query) == expected
    end

    test "using or_where query expression", %{expected: expected} do
      query =
        from takes in "takes",
          where: takes.cno == "CS112",
          or_where: takes.cno == "CS114",
          select: takes.sno,
          order_by: [desc: takes.sno],
          distinct: true

      assert Repo.all(query) == expected
    end
  end
end
