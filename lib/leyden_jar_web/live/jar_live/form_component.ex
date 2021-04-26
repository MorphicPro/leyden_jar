defmodule LeydenJarWeb.JarLive.FormComponent do
  use LeydenJarWeb, :live_component

  alias LeydenJar.Jars

  @impl true
  def update(%{jar: jar} = assigns, socket) do
    changeset = Jars.change_jar(jar)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"jar" => jar_params},
        %{assigns: %{user_id: user_id}} = socket
      ) do
    changeset =
      socket.assigns.jar
      |> Jars.change_jar(jar_params)
      |> Map.put(:action, :validate)
      |> Map.put(:user_id, user_id)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"jar" => jar_params}, %{assigns: %{user_id: user_id}} = socket) do
    save_jar(
      socket,
      socket.assigns.action,
      jar_params |> Map.put("user_id", user_id)
    )
  end

  defp save_jar(socket, :edit, jar_params) do
    case Jars.update_jar(socket.assigns.jar, jar_params) do
      {:ok, _jar} ->
        {:noreply,
         socket
         |> put_flash(:info, "Jar updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_jar(socket, :new, jar_params) do
    case Jars.create_jar(jar_params) do
      {:ok, _jar} ->
        {:noreply,
         socket
         |> put_flash(:info, "Jar created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
