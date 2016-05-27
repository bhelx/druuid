defmodule Druuid.Mixfile do
  use Mix.Project

  def project do
    [app: :druuid,
     version: "0.1.2",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  defp description do
    "Date-relative (and relatively universally unique) UUID generation. Based on https://github.com/recurly/druuid"
  end

  defp package do
    [
      name: :druuid,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Benjamin Eckel"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/bhelx/druuid"}
    ]
  end
end
