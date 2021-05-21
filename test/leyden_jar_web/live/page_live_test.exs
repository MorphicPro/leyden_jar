defmodule LeydenJarWeb.PageLiveTest do
  use LeydenJarWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Leyden Jar"
    assert render(page_live) =~ "Welcome to Leyden Jar"
  end
end
