defmodule LeydenJar.Repo.Migrations.CreateJars do
  use Ecto.Migration

  def change do
    create table(:jar_posts) do
      add :full_json, :string, null: false
      add :jar_id, references(:jars, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:jar_posts, [:jar_id])
  end

end
