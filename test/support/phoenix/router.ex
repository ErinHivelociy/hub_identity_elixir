defmodule HubIdentityElixir.TestRouter do
  use Phoenix.Router
  use HubIdentityElixir.Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  scope "/", HubIdentityElixir.Phoenix do
    pipe_through(:browser)

    hub_identity_routes()
  end

  scope "/" do
    pipe_through(:browser)

    get("/", HubIdentityElixir.TestController, :index)
  end

  scope "/" do
    pipe_through([:browser, :require_authenticated_user])

    get("/other/path", HubIdentityElixir.TestController, :other)
  end
end
