defmodule Euclid.MixProject do
  use Mix.Project

  def project do
    [
      app: :euclid,
      deps: deps(),
      description: "Shared functions for Elixir projects",
      dialyzer: [
        plt_add_apps: [:ex_unit]
      ],
      docs: docs(),
      elixir: "~> 1.9",
      elixirc_options: [warnings_as_errors: true],
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Euclid",
      source_url: "https://github.com/RatioPBC/euclid",
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
      source_url: "https://github.com/RatioPBC/euclid",
      start_permanent: Mix.env() == :prod,
      version: version()
    ]
  end

  defp docs do
    [
      main: "Euclid",
      extras: ["README.md"]
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
      extra_applications: [:crypto, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:mix_audit, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
