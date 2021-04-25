defmodule LeydenJar.Repo.Migrations.CreateJars do
  use Ecto.Migration

  def change do
    create table(:jars) do
      add :api_key_hash, :string, null: false
      add :node, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:jars, [:api_key_hash])
    create unique_index(:jars, [:node])
    create index(:jars, [:user_id])
  end
end
