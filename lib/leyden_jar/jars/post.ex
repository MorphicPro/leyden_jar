defmodule LeydenJar.Jars.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jar_posts" do
    field :full_json, :string
    field :jar_id, :id
    timestamps()
  end

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, [:full_json, :jar_id])
    |> validate_required([:full_json, :jar_id])
  end
end
