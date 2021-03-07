defmodule HubIdentityElixir.Phoenix.SessionController do
  @moduledoc false
  use Phoenix.Controller, namespace: HubIdentityElixir

  alias HubIdentityElixir.{Authentication, HubIdentity}

  @public_key Application.get_env(:hub_identity_elixir, :public_key)

  def new(conn, _params) do
    redirect(
      conn,
      external: "#{HubIdentity.hub_identity_url()}/browser/v1/providers?api_key=#{@public_key}"
    )
  end

  def create(%Plug.Conn{req_cookies: %{"_hub_identity_access" => cookie_id}} = conn, _params) do
    with current_user when is_map(current_user) <- HubIdentity.get_current_user(cookie_id) do
      Authentication.log_in_user(conn, current_user)
    end
  end

  def create(conn, _params) do
    Authentication.log_out_user(conn)
  end

  def destroy(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> Authentication.log_out_user()
  end
end
