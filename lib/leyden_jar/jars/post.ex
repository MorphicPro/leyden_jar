defmodule LeydenJar.Jars.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jar_posts" do
    field :full_json, :string
    field :jar_id, :id
    field :session_id, :id
    field :body, :map
    # belongs_to :jar, LeydenJar.Jars.Jar
    # belongs_to :session, LeydenJar.Jar.Session
    timestamps()
  end

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, [:full_json, :jar_id, :session_id])
    |> put_body(attrs)
    |> validate_required([:full_json, :jar_id, :session_id])
  end

  def change_jsonb(jar, attrs) do
    jar
    |> cast(attrs, [:full_json, :jar_id])
    |> put_body()
    |> validate_required([:full_json, :jar_id])
  end

  defp put_body(cs, %{full_json: full_json}) do
    cs
    |> put_change(:body, Jason.decode!(full_json))
  end

  defp put_body(cs) do
    cs
    |> put_change(:body, Jason.decode!(cs.data.full_json))
  end
end
