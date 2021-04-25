defmodule LeydenJar.Jars do
  @moduledoc """
  The Jars context.
  """

  import Ecto.Query, warn: false
  alias LeydenJar.Repo

  alias LeydenJar.Jars.Jar

  @doc """
  Returns the list of jars.

  ## Examples

      iex> list_jars()
      [%Jar{}, ...]

  """
  def list_jars do
    Repo.all(Jar)
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
  def get_jar!(id), do: Repo.get!(Jar, id)

  @doc """
  Creates a jar.

  ## Examples

      iex> create_jar(%{field: value})
      {:ok, %Jar{}}

      iex> create_jar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_jar(attrs \\ %{}) do
    %Jar{}
    |> Jar.changeset(attrs)
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
  def delete_jar(%Jar{} = jar) do
    Repo.delete(jar)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking jar changes.

  ## Examples

      iex> change_jar(jar)
      %Ecto.Changeset{data: %Jar{}}

  """
  def change_jar(%Jar{} = jar, attrs \\ %{}) do
    Jar.changeset(jar, attrs)
  end
end
