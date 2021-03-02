defmodule HubIdentityElixir.Phoenix.SessionController do
  @moduledoc false
  use Phoenix.Controller, namespace: HubIdentityElixir

  alias HubIdentityElixir.{Authentication, HubIdentity}

  def new(conn, _params) do
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

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, %{"access_token" => _} = tokens} <-
           HubIdentity.authenticate(%{email: email, password: password}),
         {:ok, current_user} <- HubIdentity.build_current_user(tokens) do
      Authentication.log_in_user(conn, current_user)
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: "/sessions/new")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> Authentication.log_out_user()
  end

  defp base_module(%Plug.Conn{private: %{phoenix_endpoint: endpoint}}) do
    base = Module.split(endpoint) |> hd()
    String.to_existing_atom("Elixir.#{base}.LayoutView")
  end
end
