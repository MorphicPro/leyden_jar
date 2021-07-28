defmodule LeydenJar.Repo.Migrations.AddJarSessions do
  use Ecto.Migration

  def change do
    create table(:jar_sessions) do
      add :wh, :integer, null: false
      add :state, :integer, null: false
      add :jar_id, references(:jars, on_delete: :nothing), null: false
      timestamps()
    end

    alter table(:jar_posts) do
      add :session_id, references(:jar_sessions, on_delete: :nothing)
    end

    create index(:jar_sessions, [:wh])
    create index(:jar_sessions, [:jar_id])
    create unique_index(:jar_sessions, [:wh, :jar_id], name: :wh_state_index)

    create index(:jar_posts, [:session_id])

  end

end
