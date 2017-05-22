defmodule Analytics.Mixfile do
  use Mix.Project

  def project do
    [app: :analytics,
     version: "0.1.5",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :poison, :httpoison, :money,:currency]]
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
    [ 	
		{:poison, "~> 3.1",override: :true},
		{:httpoison, "~> 0.11.0"},
		{:money, "~> 1.2"},
		{:currency, github: "MediciImmobilien/currency"}
		
	
	]
  end
end
