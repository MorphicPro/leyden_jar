defmodule LeydenJar.Repo do
  use Ecto.Repo,
    otp_app: :leyden_jar,
    adapter: Ecto.Adapters.Postgres
end
