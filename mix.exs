defmodule LocalflavorGr.MixProject do
  use Mix.Project

  def project do
    [
      app: :localflavor_gr,
      version: "0.1.0",
      elixir: "~> 1.8",
      description: description(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "LocalflavorGR",
      source_url: "https://github.com/spapas/localflavor-gr"
    ]
  end

  defp description() do
    "A very simple project for validating 9-digit greek tax numbers and 11-digit greek social security numbers."
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*  LICENSE* ),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/spapas/localflavor-gr"}
    ]
  end

  def application do
    []
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
