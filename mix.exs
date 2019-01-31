defmodule Printex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :printex,
      version: "1.0.0",
      elixir: "~> 1.8.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "Console Printing with colors and background colors",
      package: package(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  def package do
    [
      maintainers: ["Blackode", "Ahamtech"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/blackode/printex"}
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp aliases do
    [docs: ["docs", &copy_images/1]]
  end

  defp copy_images(_) do
    File.cp_r("assets", "doc/assets", fn source, destination ->
      IO.gets("Overwriting #{destination} by #{source}. Type y to confirm. ") == "y\n"
    end)

    File.cp_r("doc", "docs", fn _source, _destination ->
      true
    end)
  end

  defp deps do
    [
      {:ex_doc, github: "elixir-lang/ex_doc", override: true, only: :dev},
      {:earmark, "~> 1.0", only: :dev},
      {:dialyxir, "~> 0.3", only: [:dev]}
    ]
  end
end
