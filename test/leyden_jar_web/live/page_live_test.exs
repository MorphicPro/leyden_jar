defmodule LeydenJarWeb.PageLiveTest do
  use LeydenJarWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcone to Leyden Jar"
    assert render(page_live) =~ "Welcone to Leyden Jar"
  end
end
