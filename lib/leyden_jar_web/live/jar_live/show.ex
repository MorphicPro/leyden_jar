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
  @spec handle_params(map, any, Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_params(%{"id" => id}, _, socket) do
    jar = Jars.get_jar!(id)
    session = Jars.get_latest_session_from_jar_id!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:jar, jar)
     |> assign(:session, session)}
  end

  @impl true
  def handle_event(
        "load-chart",
        _,
        %{assigns: %{jar: %LeydenJar.Jars.Jar{id: id}}} = socket
      ) do
    # sql = """
    # select * from jar_posts jp where (jp.body ->> 'wh')::int in
    # (SELECT distinct (jp2.body #>>'{wh}')::int AS wh from jar_posts jp2 order by wh desc limit 1)
    # order by jp.id desc;
    # """

    # %Postgrex.Result{rows: rows, columns: columns} =
    #   Ecto.Adapters.SQL.query!(
    #     LeydenJar.Repo,
    #     sql
    #   )

    # {_, body_index} =
    #   columns
    #   |> Enum.with_index()
    #   |> Enum.find(fn {value, _index} -> value == "body" end)
    #   |> IO.inspect()

    # for row <- rows do
    #   Enum.at(row, body_index) |> IO.inspect()
    # end

    # data =
    #   Enum.map(rows, fn row -> Enum.at(row, body_index) end)
    #   |> Enum.map(fn %{"amp" => amp, "temp" => temp} ->
    #     %{amp: scaleString(amp, 1000, 2), temp: scaleString(temp, 10, 1)}
    #   end)

    # posts =
    #   from(p in LeydenJar.Jars.Post, where: p.jar_id == ^id, order_by: :inserted_at, limit: 1000)
    #   |> LeydenJar.Repo.all()

    posts_q = from p in LeydenJar.Jars.Post, order_by: [asc: :inserted_at]

    %{posts: posts} =
      from(s in LeydenJar.Jars.Session,
        where: s.jar_id == ^id,
        order_by: [desc: :inserted_at],
        limit: 1,
        preload: [posts: ^posts_q]
      )
      |> LeydenJar.Repo.one()

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
