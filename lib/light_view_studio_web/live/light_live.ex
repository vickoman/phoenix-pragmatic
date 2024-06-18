defmodule LightViewStudioWeb.LightLive do
  use LightViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center text-indigo-800 text-cool-gray-900 font-extrabold text-4xl mb-8">Front Portch Light</h1>
    <div id="light">
      <div class="meter">
        <span  style={"width: #{@brightness}%;"}>
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

  def handle_event("update", %{"brightness" => brightness}, socket) do
    brightness = String.to_integer(brightness)
    socket = assign(socket, brightness: brightness)
    {:noreply, socket}
  end
end
