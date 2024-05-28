defmodule E1Test do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert_all("students", [
      [sno: "S1"],
      [sno: "S2"],
      [sno: "S3"]
    ])

    Repo.insert_all("take", [
      [sno: "S1", cno: "CS112"],
      [sno: "S2", cno: "CS111"],
      [sno: "S3", cno: "CS112"]
    ])

    %{expected: ["S3", "S1"]}
  end

  describe "E1 - Who takes CS112?" do
    test "query", %{expected: expected} do
      query =
        from t in "take",
          where: t.cno == "CS112",
          select: t.sno,
          order_by: [desc: t.sno]

      assert Repo.all(query) == expected
    end
  end
end
