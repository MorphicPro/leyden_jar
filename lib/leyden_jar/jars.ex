defmodule LeydenJar.Jars do
  @type id() :: integer()
  @type attrs() :: map | nil

  @moduledoc """
  The Jars context.
  """

  import Ecto.Query, warn: false
  alias LeydenJar.Repo

  alias LeydenJar.Jars.{Jar, Post, Session}

  @spec list_jars :: list(Jar.t())
  @doc """
  Returns the list of jars.

  ## Examples

      iex> list_jars()
      [%Jar{}, ...]

  """
  def list_jars() do
    Repo.all(Jar)
  end

  @spec list_jars_by_user_id(id()) :: list(User.t())
  def list_jars_by_user_id(user_id) do
    sessions_sq = from(s in Session, order_by: [desc: s.wh])

    from(j in Jar, where: j.user_id == ^user_id, preload: [jar_sessions: ^sessions_sq])
    |> Repo.all()
  end

  @doc """
  Gets a single jar.

  Raises `Ecto.NoResultsError` if the Jar does not exist.

  ## Examples

      iex> get_jar!(123)
      %Jar{}

      iex> get_jar!(456)
      ** (Ecto.NoResultsError)

  """
  def get_jar!(id, options \\ []) do
    preload = Keyword.get(options, :preload, [])

    from(j in Jar, where: j.id == ^id)
    |> from(preload: ^preload)
    |> Repo.one!()
  end

  def get_latest_session_from_jar_id!(id) do
    from(s in Session,
      where: s.jar_id == ^id,
      order_by: [desc: s.wh],
      preload: [:posts],
      limit: 1
    )
    |> Repo.one!()
  end

  @doc """
  Gets a jar by node and api_key.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %Jar{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  @spec get_jar_by_node_and_api_key(binary, binary) :: Jar.t() | nil
  def get_jar_by_node_and_api_key(node, api_key)
      when is_binary(node) and is_binary(api_key) do
    jar = Repo.get_by(Jar, node: node)
    if Jar.valid_api_key?(jar, api_key), do: jar
  end

  @doc """
  Creates a jar.

  ## Examples

      iex> create_jar(%{field: value})
      {:ok, %Jar{}}

      iex> create_jar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_jar(attrs()) :: {:ok, Jar.t()} | {:error, Ecto.Changeset.types()}
  def create_jar(attrs \\ %{}) do
    %Jar{}
    |> Jar.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_session(attrs()) :: {:ok, Session.t()} | {:error, Ecto.Changeset.types()}
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a jar.

  ## Examples

      iex> update_jar(jar, %{field: new_value})
      {:ok, %Jar{}}

      iex> update_jar(jar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_jar(Jar.t(), attrs()) :: {:error, Ecto.Changeset.t()} | {:ok, Jar.t()}
  def update_jar(%Jar{} = jar, attrs) do
    jar
    |> Jar.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a jar.

  ## Examples

      iex> delete_jar(jar)
      {:ok, %Jar{}}

      iex> delete_jar(jar)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_jar(Jar.t()) :: {:ok, Jar.t()} | {:error, Ecto.Changeset.t()}
  def delete_jar(%Jar{} = jar) do
    Repo.delete(jar)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking jar changes.

  ## Examples

      iex> change_jar(jar)
      %Ecto.Changeset{data: %Jar{}}

  """
  @spec change_jar(Jar.t(), attrs()) :: Ecto.Changeset.t()
  def change_jar(%Jar{} = jar, attrs \\ %{}) do
    Jar.changeset(jar, attrs)
  end

  @doc """
  Creates a jar.

  ## Examples

      iex> create_jar_post(%{field: value})
      {:ok, %Jar{}}

      iex> create_jar_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_jar_post(attrs()) :: {:ok, Jar.t()} | {:error, Ecto.Changeset.t()}
  def create_jar_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end
end
