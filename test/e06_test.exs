defmodule E6Test do
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

    %{expected: ["S1", "S3"]}
  end

  describe "E6 - Who takes a course which is not CS112?" do
    test "query", %{expected: expected} do
      query =
        from t in "take",
          where: t.cno != "CS112",
          select: t.sno,
          distinct: true

      actual = query |> Repo.all() |> Enum.sort()
      assert actual == expected
    end
  end
end
