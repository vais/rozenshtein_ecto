defmodule CompositeKeysTest do
  use ExUnit.Case, async: true
  alias RozenshteinEcto.Repo
  import Ecto.Query

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    Repo.insert_all("professors", [
      [fname: "john", lname: "smith"],
      [fname: "mary", lname: "smith"],
      [fname: "john", lname: "brown"],
      [fname: "mary", lname: "brown"]
    ])

    Repo.insert_all("teach", [
      [fname: "john", lname: "smith", cno: "CS111"],
      [fname: "mary", lname: "smith", cno: "CS112"],
      [fname: "john", lname: "brown", cno: "CS112"],
      [fname: "mary", lname: "brown", cno: "CS113"],
      [fname: "mary", lname: "smith", cno: "CS113"],
      [fname: "john", lname: "brown", cno: "CS113"]
    ])

    :ok
  end

  test "What are full names and ages of professors who teach CS112?" do
    expected = [
      "mary smith",
      "john brown"
    ]

    query =
      from p in "professors",
        join: t in "teach",
        on: p.fname == t.fname and p.lname == t.lname,
        where: t.cno == "CS112",
        select: fragment("concat(?, ' ', ?)", p.fname, p.lname),
        order_by: [desc: 1],
        distinct: true

    assert Repo.all(query) == expected
  end

  test "Which courses are taught by at least two professors?" do
    expected = ["CS112", "CS113"]

    query =
      from t1 in "teach",
        join: t2 in "teach",
        on: t1.fname == t2.fname and t1.lname == t2.lname,
        where: t1.cno != t2.cno,
        select: t1.cno,
        order_by: t1.cno,
        distinct: true

    assert Repo.all(query) == expected
  end
end
