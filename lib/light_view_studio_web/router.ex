defmodule LightViewStudioWeb.Router do
  use LightViewStudioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LightViewStudioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LightViewStudioWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/light", LightLive
    live "/license", LicenseLive
    live "/sales-dashboard", SalesDashboardLive
    live "/search", SearchLive
    live "/search-flights", SearchFlightsLive
    live "/autocomplete", AutocompleteLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", LightViewStudioWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:light_view_studio, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LightViewStudioWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
