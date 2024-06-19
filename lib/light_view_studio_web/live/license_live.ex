defmodule LightViewStudioWeb.LicenseLive do
  use LightViewStudioWeb, :live_view

  alias LightViewStudio.Licenses
  import Number.Currency
  def mount(_params, _session, socket) do
    seats = 2
    socket = assign(socket, seats: seats, amount: Licenses.calculate(seats))
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Team License</h1>
    <div id="license">
      <div class="card">
        <div class="content">
          <div class="seats">
            <img src="images/license.svg">
            <span>
              Your license is currently for
              <strong><%= @seats %></strong> seats.
            </span>
          </div>
          <form phx-change="update">
            <input type="range" min="1" max="10"
                  name="seats" value={@seats} />
          </form>
          <div class="amount">
            <%= number_to_currency(@amount) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("update", %{"seats" => seats}, socket) do
    amount = Licenses.calculate(String.to_integer(seats))
    socket = assign(socket, amount: amount, seats: String.to_integer(seats))
    {:noreply, socket}
  end
end
