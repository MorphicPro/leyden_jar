defmodule LeydenJarWeb.JarLive.Show do
  use LeydenJarWeb, :live_view

  alias LeydenJar.Jars
  alias LeydenJar.Accounts

  @impl true
  def mount(_params, session, socket) do
    current_user =
      session["user_token"] && Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:jar, Jars.get_jar!(id))}
  end

  defp page_title(:show), do: "Show Jar"
  defp page_title(:edit), do: "Edit Jar"
end
