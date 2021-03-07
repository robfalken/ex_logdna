defmodule ExLogdna.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_logdna,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.0"},
      {:mox, "~> 1.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "ex_logdna",
      description:
        "A logger backend to send application logs to LogDNA through their ingestion API.",
      links: %{},
      licenses: ["MIT"],
      source_url: "https://github.com/robertfalken/ex_logdna",
      homepage_url: "https://github.com/robertfalken/ex_logdna"
    ]
  end
end
