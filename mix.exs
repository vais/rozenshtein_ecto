defmodule RozenshteinEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :rozenshtein_ecto,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RozenshteinEcto.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.11.0"},
      {:postgrex, ">= 0.0.0"},
      {:ecto_dbg, "~> 0.1.0"}
    ]
  end
end
