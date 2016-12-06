defmodule Sensor.Mixfile do
  use Mix.Project

  def project do
    [app: :sensor,
     version: "0.1.4",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package()
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {Sensor, []}]
  end

  def package do
    [
      maintainers: ["Jon Medding"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/jmedding/sensor"}
    ]
  end

  defp description do
    "An OTP application for interacting with hardware sensors"
  end

  defp deps do
    [{:ex_doc, "~> 0.10", only: :dev},
     {:dialyxir, "~> 0.4", only: [:dev]},
     {:credo, "~> 0.4", only: [:dev, :test]}
    ]
  end
end
