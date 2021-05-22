defmodule LeydenJar.Repo.Migrations.AddIndexToJarPostsBody do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX jar_post_body ON jar_posts USING GIN(body)")
  end

  def down do
    execute("DROP INDEX jar_post_body")
  end
end
