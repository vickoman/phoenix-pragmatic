defmodule LightViewStudioWeb.SalesDashboardLive do
  use LightViewStudioWeb, :live_view

  alias LightViewStudio.Sales
  import Number.Currency
  import Number.Percentage

  def mount(_params, _session, socket) do
    socket = assign_stats(socket)
    {:ok, socket}
  end

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="name">
            Mew Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= number_to_currency(@sales_mount) %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= number_to_percentage(@satisfaction, precision: 0) %>
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
      </div>
      <button phx-click="refresh">
        <img src="images/refresh.svg" alt="Refresh icon" />
        Refresh
      </button>
    </div>
    """
  end

  def handle_event("refresh", _, socket) do
    {:noreply, assign_stats(socket)}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_mount: Sales.sales_mount(),
      satisfaction: Sales.satisfaction())
  end
end
