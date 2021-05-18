defmodule LeydenJar.JarsTest do
  use LeydenJar.DataCase

  alias LeydenJar.Jars

  describe "jars" do
    alias LeydenJar.Jars.Jar

    # @valid_attrs %{api_key_hash: "some api_key_hash", node: "some node"}
    # @update_attrs %{api_key_hash: "some updated api_key_hash", node: "some updated node"}
    @invalid_attrs %{api_key_hash: nil, node: nil}

    def jar_fixture(attrs \\ %{}) do
      user = LeydenJar.AccountsFixtures.user_fixture()
      {:ok, jar} =
        attrs
        |> Enum.into(%{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name(), user_id: user.id})
        |> Jars.create_jar()

      jar
    end

    test "list_jars/0 returns all jars" do
      jar = jar_fixture()
      [j|_h] = Jars.list_jars()
      assert j.id == jar.id
    end

    test "get_jar!/1 returns the jar with given id" do
      jar = jar_fixture()
      assert Jars.get_jar!(jar.id).api_key_hash == jar.api_key_hash
    end

    test "create_jar/1 with valid data creates a jar" do
      user = LeydenJar.AccountsFixtures.user_fixture()
      params = %{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name(), user_id: user.id}
      assert {:ok, %Jar{} = jar} = Jars.create_jar(params)
      assert jar.node == params.node
    end

    test "create_jar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jars.create_jar(@invalid_attrs)
    end

    test "update_jar/2 with valid data updates the jar" do
      jar = jar_fixture()
      params = %{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name()}

      assert {:ok, %Jar{} = jar} = Jars.update_jar(jar, params)
      assert jar.node == params.node
    end

    test "update_jar/2 with invalid data returns error changeset" do
      jar = jar_fixture()
      assert {:error, %Ecto.Changeset{}} = Jars.update_jar(jar, @invalid_attrs)
      %{id: id} = Jars.get_jar!(jar.id)
      assert jar.id == id
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
