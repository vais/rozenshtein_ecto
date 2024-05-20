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

    Repo.insert_all("takes", [
      [sno: "S1", cno: "CS112"],
      [sno: "S1", cno: "CS113"],
      [sno: "S2", cno: "CS112"],
      [sno: "S3", cno: "CS111"],
      [sno: "S3", cno: "CS113"]
    ])

    %{expected: ["S3", "S4"]}
  end

  describe "E5 - Who does not take CS112?" do
    test "query", %{expected: expected} do
      who_takes =
        from t in "takes",
          where: t.cno == "CS112",
          select: t.sno

      who_does_not_take =
        from s in "students",
          where: s.sno not in subquery(who_takes),
          select: s.sno

      actual = who_does_not_take |> Repo.all() |> Enum.sort()
      assert actual == expected
    end
  end
end
