defmodule E2Test do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert_all("students", [
      [sno: "S1", name: "Suzie"],
      [sno: "S2", name: "Jeremy"],
      [sno: "S3", name: "Lizzie"]
    ])

    Repo.insert_all("take", [
      [sno: "S1", cno: "CS112"],
      [sno: "S2", cno: "CS111"],
      [sno: "S3", cno: "CS112"]
    ])

    %{expected: ["Lizzie", "Suzie"]}
  end

  describe "E2 - What are the names of students who take CS112" do
    test "query", %{expected: expected} do
      query =
        from student in "students",
          join: take in "take",
          on: student.sno == take.sno,
          where: take.cno == "CS112",
          select: student.name,
          order_by: student.name

      assert Repo.all(query) == expected
    end
  end
end
