defmodule LightViewStudioWeb.SearchFlightsLive do
  use LightViewStudioWeb, :live_view

  alias LightViewStudio.Flights
  def mount(_params, _session, socket) do
    {:ok, assign(socket, number: "", flights: [], loading: false)}
  end

  def render(assigns) do
    ~H"""
    <h1>Search Flights</h1>
     <div id="search">

     <form phx-submit="number-search">
        <input type="text" name="number" value={@number}
               placeholder="Flight Number"
          readonly={@loading} />
        <button type="submit">
          <img src="images/search.svg">
        </button>
      </form>

      <%= if @loading do %>
        <div class="loader">Loading...</div>
      <% end %>

      <div class="flights">
        <ul>
        <%= for flight <- @flights do %>
          <li>
              <div class="first-line">
                <div class="number">
                  Flight #<%= flight.number %>
                </div>
                <div class="origin-destination">
                    <img src="images/location.svg">
                    <%= flight.origin %> to
                    <%= flight.destination %>
                  </div>
              </div>
              <div class="second-line">
                <div class="departs">
                  Departs: <%= format_time(flight.departure_time) %>
                </div>
                <div class="arrives">
                  Arrives: <%= format_time(flight.arrival_time) %>
                </div>
              </div>
          </li>
        <% end %>
        </ul>
      </div>
    </div>
    """
  end

  defp format_time(time) do
    Timex.format!(time, "%b %d at %H:%M", :strftime)
  end

  def handle_event("number-search", %{"number" => number}, socket) do
    send(self(), {:run_number_search, number})

    socket =
      assign(socket,
        number: number,
        flights: [],
        loading: true
      )

    {:noreply, socket}
  end

  def handle_info({:run_number_search, number}, socket) do
    case Flights.search_by_number(number) do
      [] ->
        socket =
          socket
          |> put_flash(:error, "No flights found for number #{number}")
          |> assign(flights: [], loading: false)
        {:noreply, socket}
      flights ->
        socket =
          socket
          |> clear_flash()
          |> assign(flights: flights, loading: false)
        {:noreply, socket}
    end
  end
end
