defmodule LightViewStudio.Repo do
  use Ecto.Repo,
    otp_app: :light_view_studio,
    adapter: Ecto.Adapters.Postgres
end
