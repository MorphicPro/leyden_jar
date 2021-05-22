defmodule LeydenJar.Jars.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jar_posts" do
    field :full_json, :string
    field :jar_id, :id
    field :body, :map

    timestamps()
  end

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, [:full_json, :jar_id])
    |> validate_required([:full_json, :jar_id])
  end

  # (from p in LeydenJar.Jars.Post, select: [p.id, p.inserted_at, p.body], group_by: [p.id, fragment("? #>> ?", p.body, "{wh}")]) |> LeydenJar.Repo.all
  # for post <- posts, do: LeydenJar.Jars.Post.change_jsonb(post, %{}) |> LeydenJar.Repo.update
  def change_jsonb(jar, attrs) do
    jar
    |> cast(attrs, [:full_json, :jar_id])
    |> put_body()
    |> validate_required([:full_json, :jar_id])
  end

  defp put_body(cs) do
    cs
    |> put_change(:body, Jason.decode!(cs.data.full_json))
  end
end
