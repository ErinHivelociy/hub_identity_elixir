defmodule HubIdentityElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :hub_identity_elixir,
      version: "0.1.60",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "HubIdentityElixir",
      source_url: "https://github.com/ErinHivelociy/hub_identity_elixir",
      homepage_url: "https://stage-identity.hubsynch.com/",
      docs: [main: "HubIdentityElixir.HubIdentity", extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: [:dev]},
      {:gettext, "~> 0.11"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.1"},
      {:phoenix, "~> 1.5.7"},
      {:phoenix_html, "~> 2.11"}
    ]
  end

  defp description do
    "An elixir client library for HubIdentity"
  end

  defp package do
    [
      maintainers: ["Erin Boeger"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/ErinHivelociy/hub_identity_elixir"}
    ]
  end
end
