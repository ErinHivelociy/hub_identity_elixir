defmodule HubIdentityElixir.Phoenix.SessionController do
  @moduledoc false
  use Phoenix.Controller, namespace: HubIdentityElixir

  alias HubIdentityElixir.{Authentication, HubIdentity}

  def new(conn, _params) do
    redirect(
      conn,
      external: "#{HubIdentity.hub_identity_url()}/browser/v1/providers?api_key=#{public_key()}"
    )
  end

  def create(conn, %{"user_token" => user_token}) do
    with current_user when is_map(current_user) <- HubIdentity.get_current_user(user_token) do
      Authentication.login_user(conn, current_user)
    end
  end

  def create(conn, _params) do
    Authentication.logout_user(conn)
  end

  def destroy(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> Authentication.logout_user()
  end

  defp public_key do
    Application.get_env(:hub_identity_elixir, :public_key)
  end
end
