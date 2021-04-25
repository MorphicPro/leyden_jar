defmodule LeydenJar.JarsTest do
  use LeydenJar.DataCase

  alias LeydenJar.Jars

  describe "jars" do
    alias LeydenJar.Jars.Jar

    @valid_attrs %{api_key_hash: "some api_key_hash", node: "some node"}
    @update_attrs %{api_key_hash: "some updated api_key_hash", node: "some updated node"}
    @invalid_attrs %{api_key_hash: nil, node: nil}

    def jar_fixture(attrs \\ %{}) do
      {:ok, jar} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Jars.create_jar()

      jar
    end

    test "list_jars/0 returns all jars" do
      jar = jar_fixture()
      assert Jars.list_jars() == [jar]
    end

    test "get_jar!/1 returns the jar with given id" do
      jar = jar_fixture()
      assert Jars.get_jar!(jar.id) == jar
    end

    test "create_jar/1 with valid data creates a jar" do
      assert {:ok, %Jar{} = jar} = Jars.create_jar(@valid_attrs)
      assert jar.api_key_hash == "some api_key_hash"
      assert jar.node == "some node"
    end

    test "create_jar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jars.create_jar(@invalid_attrs)
    end

    test "update_jar/2 with valid data updates the jar" do
      jar = jar_fixture()
      assert {:ok, %Jar{} = jar} = Jars.update_jar(jar, @update_attrs)
      assert jar.api_key_hash == "some updated api_key_hash"
      assert jar.node == "some updated node"
    end

    test "update_jar/2 with invalid data returns error changeset" do
      jar = jar_fixture()
      assert {:error, %Ecto.Changeset{}} = Jars.update_jar(jar, @invalid_attrs)
      assert jar == Jars.get_jar!(jar.id)
    end

    test "delete_jar/1 deletes the jar" do
      jar = jar_fixture()
      assert {:ok, %Jar{}} = Jars.delete_jar(jar)
      assert_raise Ecto.NoResultsError, fn -> Jars.get_jar!(jar.id) end
    end

    test "change_jar/1 returns a jar changeset" do
      jar = jar_fixture()
      assert %Ecto.Changeset{} = Jars.change_jar(jar)
    end
  end
end
