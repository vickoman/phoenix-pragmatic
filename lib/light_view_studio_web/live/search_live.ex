defmodule LightViewStudioWeb.SearchLive do
  use LightViewStudioWeb, :live_view

  alias LightViewStudio.Stores

  def mount(_params, _session, socket) do
    socket = assign(socket,
      zip: "",
      stores: [],
      loading: false
      )
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Store</h1>
    <div id="search">

      <form phx-submit="search">
        <input type="text" name="zip" value={@zip}
              placeholder="Enter ZIP code" autofocus autocomplete="off"
              readonly={@loading} />
        <button type="submit">
          <img src="images/search.svg" alt="Search icon" />
        </button>
      </form>

      <%= if @loading do %>
        <div class="loader">
          Loading...
        </div>
      <%= end %>
      <div class="stores">
        <ul>
          <%=for store <- @stores do %>
          <li>
            <div class="first-line">
              <div class="name">
                <%= store.name %>
              </div>
              <div class="status">
                <%= if store.open do %>
                  <span class="open">Open</span>
                <% else %>
                  <span class="closed">Closes</span>
                <% end %>
              </div>
            </div>
            <div class="second-line">
              <div class="street">
                <img src="images/location.svg" alt="Location icon" />
                <%= store.street %>
              </div>
              <div class="phone_number">
                <img src="images/phone.svg" alt="Phone icon" />
                <%= store.phone_number %>
              </div>
            </div>
          </li>
          <%= end %>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})
    {:noreply, assign(socket,
      stores: [],
      loading: true
      )}
  end

  def handle_info({:run_zip_search, zip}, socket) do
    case Stores.search_by_zip(zip) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No stores matching \"#{zip}\"")
          |> assign(stores: [], loading: false)
        {:noreply, socket}
      stores ->
        socket =
          socket
          |> clear_flash()
          |> assign(stores: stores, loading: false)
        {:noreply, socket}

    end
  end
end
