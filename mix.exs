defmodule Euclid.MixProject do
  use Mix.Project

  def project do
    [
      app: :euclid,
      deps: deps(),
      description: "Shared functions for Elixir projects at Geometer",
      elixir: "~> 1.9",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: elixirc_paths(Mix.env()),
      package: [
        files: ~w[
          lib
          LICENSE.md
          mix.exs
          README.md
          VERSION
        ],
        licenses: ["MIT-0"],
        links: %{}
      ],
      source_url: "https://github.com/geometerio/euclid",
      start_permanent: Mix.env() == :prod,
      version: version()
    ]
  end

  defp version do
    case File.read("VERSION") do
      {:error, _} -> "0.0.0"
      {:ok, version_number} -> version_number |> String.trim()
    end
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
      {:ex_doc, "~> 0.22.1", only: :dev, runtime: false},
      {:mix_audit, "~> 0.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
