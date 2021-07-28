defmodule LeydenJarWeb.PostController do
  use LeydenJarWeb, :controller
  alias LeydenJar.Jars

  def post(conn, %{"node" => node, "apikey" => api_key, "fulljson" => full_json} = _params) do
    if jar = Jars.get_jar_by_node_and_api_key(node, api_key) do
      # start a ecto transaction
      # Find or create session for Jar.ID and full_json -> wh
      # if session found update state
      # insert post for given session and jar

      %{"wh" => wh, "state" => state} =
        full_json
        |> Jason.decode!()

      multi_results =
        Ecto.Multi.new()
        |> Ecto.Multi.run(:jar_session, fn repo, _ ->
          case repo.get_by(LeydenJar.Jars.Session, wh: wh, jar_id: jar.id) |> IO.inspect() do
            %LeydenJar.Jars.Session{} = session ->
              session
              |> LeydenJar.Jars.Session.changeset(%{state: state})
              |> repo.update()

            _ ->
              %LeydenJar.Jars.Session{}
              |> LeydenJar.Jars.Session.changeset(%{wh: wh, jar_id: jar.id, state: state})
              |> repo.insert()
          end
        end)
        |> Ecto.Multi.insert(
          :post,
          fn %{jar_session: %LeydenJar.Jars.Session{id: session_id}} ->
            LeydenJar.Jars.Post.changeset(%LeydenJar.Jars.Post{}, %{
              jar_id: jar.id,
              session_id: session_id,
              full_json: full_json
            })
          end
        )
        |> LeydenJar.Repo.transaction()

      case multi_results do
        {:ok, %{jar_session: jar_session, post: post}} ->
          Phoenix.PubSub.broadcast(
            LeydenJar.PubSub,
            "jar:#{post.jar_id}",
            {:new_post, post}
          )

          Phoenix.PubSub.broadcast(
            LeydenJar.PubSub,
            "jars",
            {:jar_updated, %{id: post.jar_id}}
          )

          Phoenix.PubSub.broadcast(
            LeydenJar.PubSub,
            "jar:#{post.jar_id}",
            {:jar_updated, %{id: post.jar_id}}
          )

          send_resp(conn, 200, "{\"success\": true}")

        _ ->
          send_resp(conn, 422, "{\"success\": false}")
      end

      # case Jars.create_jar_post(%{jar_id: jar.id, full_json: full_json}) do
      #   {:ok, post} ->
      #     Phoenix.PubSub.broadcast(
      #       LeydenJar.PubSub,
      #       "jar:#{jar.id}",
      #       {:new_post, post}
      #     )
      # end

      # case Jars.update_jar(jar, %{last_post: full_json}) do
      #   {:ok, jar} ->
      #     Phoenix.PubSub.broadcast(
      #       LeydenJar.PubSub,
      #       "jars",
      #       {:jar_updated, jar}
      #     )

      #     Phoenix.PubSub.broadcast(
      #       LeydenJar.PubSub,
      #       "jar:#{jar.id}",
      #       {:jar_updated, jar}
      #     )
      # end
    else
      send_resp(conn, 401, "{\"success\": false}")
    end

    # States:
    # 1 Not Connected
    # 2 Connected
    # 3 Charging
    # 4 Error
    # 5 Error
    # 254 ? Paused

    # Divertmode:
    # 1 normal
    # 2 eco

    # api_key_hash
    # node
    # full_json: %{
    #   "amp" => 21780, current draw on open circuit
    #   "divertmode" => 1, ?
    #   "freeram" => 221164, avaalible ram on the device
    #   "pilot" => 0, not sure.
    #   "srssi" => -42, wifi
    #   "state" => 3, see states
    #   "temp" => 188, decimal needs to shift left one spot
    #   "temp1" => false, I think triggered
    #   "temp2" => 188, decimal needs to shift left one spot
    #   "temp3" => false, I think triggered
    #   "temp4" => 302.5, decimal needs to shift left one spot
    #   "vehicle" => false, never true ignore
    #   "voltage" => 240, wall voltage
    #   "wh" => 16249
    #  }
  end
end
