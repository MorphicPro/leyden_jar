defmodule LeydenJar.Jars.Jar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jars" do
    field :api_key, :string, virtual: true
    field :api_key_hash, :string
    field :node, :string
    field :user_id, :id
    timestamps()
  end

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, [:api_key, :node, :user_id])
    |> put_api_key()
    |> put_api_key_hash()
    |> validate_required([:api_key_hash, :node, :user_id])
    |> unique_constraint(:api_key_hash)
    |> unique_constraint(:node)
  end

  @doc false
  def put_api_key_hash(%{changes: %{api_key: api_key}} = cs) do
    if api_key && cs.valid? do
      cs
      |> put_change(:api_key_hash, Bcrypt.hash_pwd_salt(api_key))
    else
      cs
    end
  end

  def put_api_key_hash(cs) do
    cs
  end

  @doc false
  def put_current_user(cs, %{id: id}) do
    cs
    |> put_change(:user_id, id)
  end

  def put_current_user(cs, _) do
    cs
  end

  @doc false
  def put_api_key(%Ecto.Changeset{data: %{api_key: null}, changes: changes} = cs)
      when map_size(changes) == 0 do
    IO.inspect(cs)

    cs
    |> put_change(:api_key, Ecto.UUID.generate())
  end

  @doc false
  def put_api_key(cs) do
    cs
  end
end
