defmodule LeydenJarWeb.PageController do
  use LeydenJarWeb, :controller

  def post(conn, params) do
    IO.inspect(params["fulljson"] |> Jason.decode!())

    # IO.inspect(conn)
    # api_key_hash
    # node
    # %{
    #   "amp" => 21780,
    #   "divertmode" => 1,
    #   "freeram" => 221164,
    #   "pilot" => 0,
    #   "srssi" => -42,
    #   "state" => 3,
    #   "temp" => 188,
    #   "temp1" => false,
    #   "temp2" => 188,
    #   "temp3" => false,
    #   "temp4" => 302.5,
    #   "vehicle" => false,
    #   "voltage" => 240,
    #   "wh" => 16249
    # }

    send_resp(conn, 200, "{\"success\": true}")
  end
end
