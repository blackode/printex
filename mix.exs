defmodule Printex.Mixfile do
  use Mix.Project

  def project do
    [app: :printex,
     version: "0.1.2",
     elixir: "~> 1.4-rc",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Console Printing with colors and backgrounds",
     package: package(),
     aliases: aliases(),
     deps: deps()]
  end

  def package do
    [
      maintainers: [" Blackode","Ahamtech"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/blackode/printex"}
    ]
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

  defp aliases do
      [docs: ["docs", &copy_images/1]]
  end

  defp copy_images(_) do
      File.cp_r "assets", "doc/assets", fn(source, destination) ->
          IO.gets("Overwriting #{destination} by #{source}. Type y to confirm. ") == "y\n"
      end

      File.cp_r "doc", "docs", fn(source, destination) ->
        true
      end
  end
  defp deps do
    [{:ex_doc, github: "elixir-lang/ex_doc", override: true,only: :dev},
     {:earmark, "~> 1.0", only: :dev}, {:dialyxir, "~> 0.3", only: [:dev]}
   ]
  end
end
