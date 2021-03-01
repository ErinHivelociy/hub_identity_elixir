defmodule HubIdentityElixir.Phoenix.ProviderController do
  @moduledoc false
  use Phoenix.Controller, namespace: HubIdentityElixir

  import Plug.Conn

  alias HubIdentityElixir.HubIdentity

  def providers(conn, _params) do
    with {:ok, providers} <- HubIdentity.get_providers() do
      layout = base_module(conn)

      conn
      |> put_layout({layout, :app})
      |> render("index.html",
        providers: providers,
        base_url: HubIdentity.hub_identity_url()
      )
    end
  end

  def authenticate(conn, %{"email" => email, "password" => password}) do
    with {:ok, %{"access_token" => _, "refresh_token" => _} = tokens} <-
           HubIdentity.authenticate(%{email: email, password: password}),
         {:ok, session_params, refresh_token} <- HubIdentity.parse_tokens(tokens) do
      conn
      |> fetch_session()
      |> put_session(:owner_uid, session_params[:owner_uid])
      |> put_session(:owner_type, session_params[:owner_type])
      |> put_session(:user_type, session_params[:user_type])
      |> put_session(:uid, session_params[:uid])
      |> put_session(:refresh_token, refresh_token)
      |> redirect(to: "/")
    end
  end

  def registration(conn, %{"email" => email, "password" => password}) do
    # Make register request to HubIdentity
    # parse response
    # if sucessful put owner_uid, owner_type, hubidentity user uid, user type into session
    # return to config return or "/" default
  end

  defp base_module(%Plug.Conn{private: %{phoenix_endpoint: endpoint}}) do
    base = Module.split(endpoint) |> hd()
    String.to_existing_atom("Elixir.#{base}.LayoutView")
  end
end
