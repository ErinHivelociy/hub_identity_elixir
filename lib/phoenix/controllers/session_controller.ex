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

  def create(conn, params) do
    with {:ok, current_user} <- HubIdentity.build_current_user(params) do
      Authentication.log_in_user(conn, current_user)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> Authentication.log_out_user()
  end
end
