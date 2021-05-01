defmodule LeydenJarWeb.JarLive.Index do
  use LeydenJarWeb, :live_view

  alias LeydenJar.Jars
  alias LeydenJar.Jars.Jar
  alias LeydenJar.Accounts

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket),
      do: Phoenix.PubSub.subscribe(LeydenJar.PubSub, "jars")

    current_user =
      session["user_token"] && Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:jars, Jars.list_jars_by_user_id(current_user.id))
     |> assign(:user_id, current_user.id)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Jar")
    |> assign(:jar, Jars.get_jar!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Jar")
    |> assign(:jar, %Jar{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Jars")
    |> assign(:jar, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    jar = Jars.get_jar!(id)
    {:ok, _} = Jars.delete_jar(jar)

    {:noreply, assign(socket, :jars, Jars.list_jars())}
  end

  @impl true
  def handle_info({:jar_updated, %{id: id} = jar}, %{assigns: %{jars: jars}} = socket) do
    jars =
      Enum.map(jars, fn
        %{id: ^id} -> jar
        p -> p
      end)

    {:noreply, assign(socket, jars: jars)}
  end

  # @impl true
  # def handle_info({:jar_updated, jar}, socket) do
  #   {:noreply, assign(socket, jar: jar)}
  # end

  defp list_jars(user_id) do
    Jars.list_jars_by_user_id(user_id)
  end
end
