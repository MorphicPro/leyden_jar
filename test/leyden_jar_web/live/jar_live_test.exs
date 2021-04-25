defmodule LeydenJarWeb.JarLiveTest do
  use LeydenJarWeb.ConnCase

  import Phoenix.LiveViewTest

  alias LeydenJar.Jars

  @create_attrs %{api_key_hash: "some api_key_hash", node: "some node"}
  @update_attrs %{api_key_hash: "some updated api_key_hash", node: "some updated node"}
  @invalid_attrs %{api_key_hash: nil, node: nil}

  defp fixture(:jar) do
    {:ok, jar} = Jars.create_jar(@create_attrs)
    jar
  end

  defp create_jar(_) do
    jar = fixture(:jar)
    %{jar: jar}
  end

  describe "Index" do
    setup [:create_jar]

    test "lists all jars", %{conn: conn, jar: jar} do
      {:ok, _index_live, html} = live(conn, Routes.jar_index_path(conn, :index))

      assert html =~ "Listing Jars"
      assert html =~ jar.api_key_hash
    end

    test "saves new jar", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.jar_index_path(conn, :index))

      assert index_live |> element("a", "New Jar") |> render_click() =~
               "New Jar"

      assert_patch(index_live, Routes.jar_index_path(conn, :new))

      assert index_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#jar-form", jar: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.jar_index_path(conn, :index))

      assert html =~ "Jar created successfully"
      assert html =~ "some api_key_hash"
    end

    test "updates jar in listing", %{conn: conn, jar: jar} do
      {:ok, index_live, _html} = live(conn, Routes.jar_index_path(conn, :index))

      assert index_live |> element("#jar-#{jar.id} a", "Edit") |> render_click() =~
               "Edit Jar"

      assert_patch(index_live, Routes.jar_index_path(conn, :edit, jar))

      assert index_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#jar-form", jar: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.jar_index_path(conn, :index))

      assert html =~ "Jar updated successfully"
      assert html =~ "some updated api_key_hash"
    end

    test "deletes jar in listing", %{conn: conn, jar: jar} do
      {:ok, index_live, _html} = live(conn, Routes.jar_index_path(conn, :index))

      assert index_live |> element("#jar-#{jar.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#jar-#{jar.id}")
    end
  end

  describe "Show" do
    setup [:create_jar]

    test "displays jar", %{conn: conn, jar: jar} do
      {:ok, _show_live, html} = live(conn, Routes.jar_show_path(conn, :show, jar))

      assert html =~ "Show Jar"
      assert html =~ jar.api_key_hash
    end

    test "updates jar within modal", %{conn: conn, jar: jar} do
      {:ok, show_live, _html} = live(conn, Routes.jar_show_path(conn, :show, jar))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Jar"

      assert_patch(show_live, Routes.jar_show_path(conn, :edit, jar))

      assert show_live
             |> form("#jar-form", jar: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#jar-form", jar: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.jar_show_path(conn, :show, jar))

      assert html =~ "Jar updated successfully"
      assert html =~ "some updated api_key_hash"
    end
  end
end
