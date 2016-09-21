defmodule Excelion.Mixfile do
  use Mix.Project

  def project do
    [app: :excelion,
     version: "0.0.3",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev},
     {:xlsx_parser, "~> 0.0.8"}]
  end

  defp description do
    """
    Excel (xlsx) file reader for Elixir.
    """
  end

  defp package do
    [# These are the default files included in the package
     name: :excelion,
     files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Akira Takahashi"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/faithandbrave/excelion"}]
  end
end
