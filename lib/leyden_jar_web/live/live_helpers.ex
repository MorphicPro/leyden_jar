defmodule LeydenJarWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `LeydenJarWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, LeydenJarWeb.PostLive.FormComponent,
        id: @post.id || :new,
        action: @live_action,
        post: @post,
        return_to: Routes.post_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, LeydenJarWeb.ModalComponent, modal_opts)
  end

  def last_post(nil), do: %{}

  def last_post(post) do
    case Jason.decode(post) do
      {:ok, result} -> result
      _ -> %{}
    end
  end

  def last_post(_), do: %{}
  def last_post(), do: %{}

  @spec jar_state(n :: any) :: String.t()
  def jar_state(n) do
    case n do
      0 -> "Starting"
      1 -> "Not Connected"
      2 -> "EV Connected"
      3 -> "Charging"
      4 -> "Vent Required"
      5 -> "Diode Check Failed"
      6 -> "GFCI Fault"
      7 -> "No Earth Ground"
      8 -> "Stuck Relay"
      9 -> "GFCI Self Test Failed"
      10 -> "Over Temperature"
      11 -> "Over Current"
      254 -> "Waiting"
      255 -> "Disabled"
      _ -> "Invalid"
    end
  end

  def updated_since(datetime) do
    {:ok, time} = Timex.format(datetime, "{relative}", :relative)
    time
  end

  def jar_state_color(n) do
    case n do
      # Starting
      0 -> " bg-gradient-to-b from-purple-100"
      # Not Connected
      1 -> " bg-gradient-to-b from-gray-200"
      # EV Connected
      2 -> " bg-gradient-to-b from-yellow-100"
      # Charging
      3 -> " bg-gradient-to-b from-green-100"
      # Vent Required
      4 -> " bg-gradient-to-b from-red-100"
      # Diode Check Failed
      5 -> " bg-red-100"
      # GFCI Fault
      6 -> " bg-red-100"
      # No Earth Ground
      7 -> " bg-red-100"
      # Stuck Relay
      8 -> " bg-red-100"
      # GFCI Self Test Failed
      9 -> " bg-red-100"
      # Over Temperature
      10 -> " bg-red-100"
      # Over Current
      11 -> " bg-red-100"
      # Waiting
      254 -> " bg-blue-100"
      # Disabled
      255 -> " bg-gray-400"
      _ -> ""
    end
  end
end
