defmodule E13Test do
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
      [cno: "CS111"],
      [cno: "CS112"],
      [cno: "CS113"],
      [cno: "CS114"]
    ])

    Repo.insert_all("take", [
      [sno: "S1", cno: "CS112"],
      [sno: "S2", cno: "CS111"],
      [sno: "S2", cno: "CS112"],
      [sno: "S2", cno: "CS114"],
      [sno: "S3", cno: "CS111"],
      [sno: "S3", cno: "CS112"],
      [sno: "S3", cno: "CS113"],
      [sno: "S3", cno: "CS114"]
    ])

    %{expected: ["S3"]}
  end

  describe "E13 - Who takes every course?" do
    test "using a left join", %{expected: expected} do
      courses = from t in "take", select: t.cno, distinct: true

      students_for_whom_there_are_courses_they_dont_take =
        from s in "students",
          cross_join: c in subquery(courses),
          left_join: t in "take",
          on: s.sno == t.sno and c.cno == t.cno,
          where: is_nil(t.cno),
          select: s.sno

      query =
        from s in "students",
          where: s.sno not in subquery(students_for_whom_there_are_courses_they_dont_take),
          select: s.sno

      assert Repo.all(query) == expected
    end

    defmacro concat(a, b) do
      quote do: fragment("concat(?, ' ', ?)", unquote(a), unquote(b))
    end

    test "using string concatenation", %{expected: expected} do
      courses = from t in "take", select: t.cno, distinct: true

      students_for_whom_there_are_courses_they_dont_take =
        from s in "students",
          cross_join: c in subquery(courses),
          where:
            concat(s.sno, c.cno) not in subquery(from t in "take", select: concat(t.sno, t.cno)),
          select: s.sno

      query =
        from s in "students",
          where: s.sno not in subquery(students_for_whom_there_are_courses_they_dont_take),
          select: s.sno

      assert Repo.all(query) == expected
    end

    test "using a type 3 query", %{expected: expected} do
      # In other words: for which students
      # does there not exist a course
      # that they do not take?

      query =
        from s in "students",
          as: :student,
          select: s.sno,
          where:
            not exists(
              from c in "courses",
                as: :course,
                select: 1,
                where:
                  not exists(
                    from t in "take",
                      select: 1,
                      where:
                        t.sno == parent_as(:student).sno and
                          t.cno == parent_as(:course).cno
                  )
            )

      assert Repo.all(query) == expected
    end
  end
end
