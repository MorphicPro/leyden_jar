defmodule LeydenJarWeb.PostController do
  use LeydenJarWeb, :controller
  alias LeydenJar.Jars

  def post(conn, %{"node" => node, "apikey" => api_key, "fulljson" => full_json} = _params) do
    if jar = Jars.get_jar_by_node_and_api_key(node, api_key) do
      Jars.create_jar_post(%{jar_id: jar.id, full_json: full_json})

      case Jars.update_jar(jar, %{last_post: full_json}) do
        {:ok, jar} ->
          Phoenix.PubSub.broadcast(
            LeydenJar.PubSub,
            "jars",
            {:jar_updated, jar}
          )

          Phoenix.PubSub.broadcast(
            LeydenJar.PubSub,
            "jar:#{jar.id}",
            {:jar_updated, jar}
          )
      end

      send_resp(conn, 200, "{\"success\": true}")
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
