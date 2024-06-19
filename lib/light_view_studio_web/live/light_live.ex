defmodule LightViewStudioWeb.LightLive do
  use LightViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10, temp: 3000)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Luces Frontales</h1>
    <div id="light">
      <div class="meter">
        <span  style={"width: #{@brightness}%; background-color: #{temp_color(@temp)}"}>
          <%= @brightness %> %
        </span>
      </div>

      <button phx-click="off">
        <img src="images/light-off.svg" width="40" height="40" >
      </button>

      <button phx-click="down">
        <img src="images/down.svg" width="40" height="40" >
      </button>


      <button phx-click="up" >
        <img src="images/up.svg" width="40" height="40" >
      </button>

      <button phx-click="on">
        <img src="images/light-on.svg" width="40" height="40" >
      </button>

      <form phx-change="update">
        <input type="range" min="0" max="100"
          name="brightness" value={@brightness} />
      </form>

      <form phx-change="change-temp">
        <input type="radio" id="3000" name="temp" value="3000"
          checked={3000 == @temp} />
        <label for="3000">3000</label>

        <input type="radio" id="4000" name="temp" value="4000"
            checked={4000 == @temp} />
        <label for="4000">4000</label>

        <input type="radio"id="5000" name="temp" value="5000"
            checked={5000 == @temp} />
        <label for="5000">5000</label>
      </form>
    </div>
    """
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &(&1 + 10))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &(&1 - 10))
    {:noreply, socket}
  end

  def handle_event("change-temp", %{"temp" => temp}, socket) do
    temp = String.to_integer(temp)
    socket = assign(socket, temp: temp)
    {:noreply, socket}
  end

  def handle_event("update", %{"brightness" => brightness}, socket) do
    brightness = String.to_integer(brightness)
    socket = assign(socket, brightness: brightness)
    {:noreply, socket}
  end

  defp temp_color(3000), do: "F1C40D"
  defp temp_color(4000), do: "#FEFF66"
  defp temp_color(5000), do: "#99CCFF"
end
