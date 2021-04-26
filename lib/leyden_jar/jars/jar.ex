defmodule LeydenJar.Jars.Jar do
  use Ecto.Schema
  import Ecto.Changeset
  alias LeydenJar.Jars.Post

  schema "jars" do
    field :api_key, :string, virtual: true
    field :api_key_hash, :string
    field :node, :string
    field :user_id, :id
    field :last_post, :string
    has_many :jar_posts, Post
    timestamps()
  end

  @doc false
  def changeset(jar, attrs) do
    jar
    |> cast(attrs, [:api_key, :node, :user_id, :last_post])
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
    cs
    |> put_change(:api_key, UUID.uuid4(:hex))
  end

  @doc false
  def put_api_key(cs) do
    cs
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_api_key?(%LeydenJar.Jars.Jar{api_key_hash: api_key_hash}, api_key)
      when is_binary(api_key_hash) and byte_size(api_key) > 0 do
    Bcrypt.verify_pass(api_key, api_key_hash)
  end

  def valid_api_key?(_, _) do
    Bcrypt.no_user_verify()
    false
  end
end
