defmodule LeydenJarWeb.JarLive.Show do
  use LeydenJarWeb, :live_view

  import Ecto.Query, warn: false

  alias LeydenJar.Jars
  alias LeydenJar.Accounts

  @impl true
  def mount(%{"id" => id}, session, socket) do
    if connected?(socket),
      do: Phoenix.PubSub.subscribe(LeydenJar.PubSub, "jar:" <> id)

    current_user =
      session["user_token"] && Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    jar = Jars.get_jar!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:jar, jar)}
  end

  @impl true
  def handle_event(
        "load-chart",
        _,
        %{assigns: %{jar: %LeydenJar.Jars.Jar{id: id} = jar}} = socket
      ) do
    IO.inspect(socket)

    posts =
      from(p in LeydenJar.Jars.Post, where: p.jar_id == ^id, order_by: :inserted_at)
      |> LeydenJar.Repo.all()

    # %{jar_posts: posts} = jar |> LeydenJar.Repo.preload([:jar_posts])

    data =
      posts
      |> Enum.map(fn %{body: %{"amp" => amp, "temp" => temp}} ->
        %{amp: scaleString(amp, 1000, 2), temp: scaleString(temp, 10, 1)}
      end)

    {:noreply,
     socket
     |> push_event("inital_data", %{new_data: data})}
  end

  @impl true
  def handle_info({:jar_updated, %{id: id}}, socket) do
    {:noreply, assign(socket, jar: Jars.get_jar!(id))}
  end

  def handle_info(
        {:new_post, %LeydenJar.Jars.Post{body: %{"amp" => amp, "temp" => temp}}},
        socket
      ) do
    {
      :noreply,
      push_event(socket, "push_data", %{
        new_data: %{
          amp: scaleString(amp, 1000, 2),
          temp: scaleString(temp, 10, 1)
        }
      })
    }
  end

  defp page_title(:show), do: "Show Jar"
  defp page_title(:edit), do: "Edit Jar"
end
