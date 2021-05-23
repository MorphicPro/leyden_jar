defmodule LeydenJarWeb.JarLiveTest do
  use LeydenJarWeb.ConnCase

  import Phoenix.LiveViewTest

  alias LeydenJar.Jars

  @create_attrs %{api_key: "some api_key_hash", node: "somenode"}
  @update_attrs %{api_key: "some updated api_key_hash", node: "someupdatednode"}
  @invalid_attrs %{api_key: nil, node: nil}

  defp fixture(:jar) do
    user = LeydenJar.AccountsFixtures.user_fixture()
    {:ok, jar} = Jars.create_jar(%{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name(), user_id: user.id})
    jar
  end

  defp create_jar(_) do
    jar = fixture(:jar)
    %{jar: jar}
  end

  describe "Index" do
    setup [:register_and_log_in_user]

    test "lists all jars", %{conn: conn, user: user} do
      {:ok, jar} = Jars.create_jar(%{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name(), user_id: user.id})
      {:ok, _index_live, html} = live(conn, Routes.jar_index_path(conn, :index))
      assert html =~ "Listing Jars"
      assert html =~ jar.node
    end

    test "saves new jar", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.jar_index_path(conn, :index))

      assert index_live |> element("a", "New Jar") |> render_click() =~
               "New Jar"

      assert_patch(index_live, Routes.jar_index_path(conn, :new))

      assert index_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      params = %{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name()}
      {:ok, _, html} =
        index_live
        |> form("#jar-form", jar: params)
        |> render_submit()
        |> follow_redirect(conn, Routes.jar_index_path(conn, :index))

      assert html =~ "Jar created successfully"
      assert html =~ params.node
    end

    test "updates jar in listing", %{conn: conn, user: user} do
      {:ok, jar} = Jars.create_jar(%{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name(), user_id: user.id})

      {:ok, index_live, _html} = live(conn, Routes.jar_index_path(conn, :index))

      assert index_live |> element("#jar-#{jar.id} a", "Edit") |> render_click() =~ "Edit Jar"

      assert_patch(index_live, Routes.jar_index_path(conn, :edit, jar))

      assert index_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"
      params = %{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name()}
      {:ok, _, html} =
        index_live
        |> form("#jar-form", jar: params)
        |> render_submit()
        |> follow_redirect(conn, Routes.jar_index_path(conn, :index))

      assert html =~ "Jar updated successfully"
      assert html =~ params.node
    end

    test "deletes jar in listing", %{conn: conn, user: user} do
      {:ok, jar} = Jars.create_jar(%{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name(), user_id: user.id})

      {:ok, index_live, _html} = live(conn, Routes.jar_index_path(conn, :index))

      assert index_live |> element("#jar-#{jar.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#jar-#{jar.id}")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user]

    test "displays jar", %{conn: conn, user: user} do
      {:ok, jar} = Jars.create_jar(%{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name(), user_id: user.id})

      {:ok, _show_live, html} = live(conn, Routes.jar_show_path(conn, :show, jar))

      assert html =~ "Showing " <> jar.node <> " Jar"
    end

    test "updates jar within modal", %{conn: conn, user: user} do
      {:ok, jar} = Jars.create_jar(%{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name(), user_id: user.id})
      {:ok, show_live, _html} = live(conn, Routes.jar_show_path(conn, :show, jar))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Jar"

      assert_patch(show_live, Routes.jar_show_path(conn, :edit, jar))

      assert show_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      # {:ok, _, html} =
      #   show_live
      #   |> form("#jar-form", jar: %{api_key: UUID.uuid4(:hex), node: Faker.Pokemon.name()})
      #   |> render_submit()
      #   |> follow_redirect(conn, Routes.jar_show_path(conn, :show, jar))

      # assert html =~ "Jar updated successfully"
      # assert html =~ "some updated api_key_hash"
    end
  end
end
