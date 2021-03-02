defmodule HubIdentityElixir.TestController do
  use Phoenix.Controller, namespace: HubIdentityElixir

  import Plug.Conn

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def other(conn, _params) do
    render(conn, "index.html")
  end
end
