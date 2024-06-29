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
    test "using a join", %{expected: expected} do
      query =
        from student in "students",
          join: take in "take",
          on: student.sno == take.sno,
          where: take.cno == "CS112",
          select: student.name,
          order_by: student.name

      assert Repo.all(query) == expected
    end

    test "using a type 3 query with the IN inter-query connector", %{expected: expected} do
      query =
        from s in "students",
          as: :student,
          where:
            "CS112" in subquery(
              from t in "take",
                where: t.sno == parent_as(:student).sno,
                select: t.cno
            ),
          select: s.name,
          order_by: s.name

      assert Repo.all_and_log(query) == expected
    end

    test "using a type 3 query with the EXISTS inter-query connector", %{expected: expected} do
      query =
        from s in "students",
          as: :student,
          where:
            exists(
              from t in "take",
                where: t.sno == parent_as(:student).sno and t.cno == "CS112",
                select: 1
            ),
          select: s.name,
          order_by: s.name

      assert Repo.all_and_log(query) == expected
    end
  end
end
