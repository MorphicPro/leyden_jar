defmodule LeydenJar.Repo.Migrations.CreateChargerPosts do
  use Ecto.Migration

  def change do
    create table(:charger_posts) do
      add :apikey, :uuid
      add :node, :string

      timestamps()
    end
  end
end
