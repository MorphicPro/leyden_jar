defmodule LeydenJarWeb.PageController do
  use LeydenJarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
