defmodule E15Test do
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

    Repo.insert_all("courses", [
      [cno: "CS111", credits: 11],
      [cno: "CS112", credits: 12],
      [cno: "CS113", credits: 13],
      [cno: "CS114", credits: 14]
    ])

    Repo.insert_all("take", [
      [sno: "S1", cno: "CS112", grade: 0],
      [sno: "S2", cno: "CS111", grade: 1],
      [sno: "S2", cno: "CS112", grade: 2],
      [sno: "S2", cno: "CS114", grade: 3],
      [sno: "S3", cno: "CS111", grade: 4],
      [sno: "S3", cno: "CS112", grade: 1],
      [sno: "S3", cno: "CS113", grade: 2],
      [sno: "S3", cno: "CS114", grade: 3]
    ])

    %{
      expected: [
        ["S1", 0 * 12 / 12],
        ["S2", (1 * 11 + 2 * 12 + 3 * 14) / (11 + 12 + 14)],
        ["S3", (4 * 11 + 1 * 12 + 2 * 13 + 3 * 14) / (11 + 12 + 13 + 14)]
      ]
    }
  end

  defmacro as_float(expression) do
    quote do: fragment("cast(? as float)", unquote(expression))
  end

  describe "E15 - What is the grade point average of each student?" do
    test "query", %{expected: expected} do
      query =
        from t in "take",
          join: c in "courses",
          on: t.cno == c.cno,
          group_by: t.sno,
          select: [t.sno, sum(t.grade * c.credits) / as_float(sum(c.credits))],
          order_by: t.sno

      assert Repo.all(query) == expected
    end
  end
end
