defmodule LeydenJar.Jars.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jar_sessions" do
    field :state, :integer
    field :wh, :integer
    field :jar_id, :id
    has_many :posts, LeydenJar.Jars.Post

    timestamps()
  end

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, [:state, :wh, :jar_id])
    |> validate_required([:state, :wh, :jar_id])
    |> unique_constraint(:wh_state_constraint, name: :wh_state_index)
    |> foreign_key_constraint(:wh)
    |> foreign_key_constraint(:jar_id)
  end
end
