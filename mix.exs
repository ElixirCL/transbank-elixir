defmodule Transbank.MixProject do
  use Mix.Project

  def project do
    [
      app: :transbank,
      package: package(),
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Transbank -non official- elixir package."
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "transbank",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/elixircl/transbank"}
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
      {:tesla, "~> 1.4"},
      {:jason, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
