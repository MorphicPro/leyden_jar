defmodule LeydenJar.Repo.Migrations.AddJsonbToJarPosts do
  use Ecto.Migration

  def change do
    alter table(:jar_posts) do
      add :body, :map, default: %{}
    end
  end
end
