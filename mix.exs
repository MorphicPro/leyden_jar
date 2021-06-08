defmodule LeydenJar.MixProject do
  use Mix.Project

  def project do
    [
      app: :leyden_jar,
      releases: [
        prod: [
          include_executables_for: [:unix],
          steps: [:assemble, :tar]
        ]
      ],
      version: "0.0.1",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [t: :test, "coveralls.html": :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LeydenJar.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 2.3"},
      {:phoenix, "~> 1.5.8"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.5.3"},
      {:postgrex, ">= 0.15.7"},
      {:phoenix_live_view, "~> 0.15.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:ecto_psql_extras, "~>0.6.2"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.2", override: true},
      {:plug_cowboy, "~> 2.4.1"},
      {:phx_gen_auth, "~> 0.7", only: [:dev], runtime: false},
      {:sobelow, "~> 0.11", only: :dev},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:floki, ">= 0.30.0", only: :test},
      {:ex_machina, "~> 2.6.0", only: :test},
      {:faker, "~> 0.16.0", only: :test},
      {:excoveralls, "0.14.1", only: [:test, :dev]},
      {:credo, "1.5.5", only: [:dev, :test], runtime: false},
      # {:sentry, "~> 8.0.3"},
      {:benchee, "~> 1.0", only: :dev},
      { :uuid, "~> 1.1" },
      {:timex, "~> 3.7.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      t: ["ecto.create --quiet", "ecto.migrate", "coveralls.html", "credo --strict"]
    ]
  end
end
