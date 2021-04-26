defmodule LeydenJar.Repo.Migrations.AddLastPostToJars do
  use Ecto.Migration

  def change do
    alter table(:jars) do
      add :last_post, :string
    end
  end
end
