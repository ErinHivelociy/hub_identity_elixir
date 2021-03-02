defmodule HubIdentityElixir.Phoenix.Router do
  @doc false
  use Phoenix.Router

  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__),
        only: [hub_identity_routes: 0]

      import HubIdentityElixir.Authentication
    end
  end

  @doc """
  HubIdentityElixir routes macro.
  Use this macro to define the HubIdentityElixir routes. This will call
  `hub_identity_routes/0`.
  ## Example
      scope "/" do
        hub_identity_routes()
      end
  """
  defmacro hub_identity_routes do
    quote do
      scope "/", alias: false, as: false do
        delete("/sessions/logout", HubIdentityElixir.Phoenix.SessionController, :delete)
        get("/sessions/new", HubIdentityElixir.Phoenix.SessionController, :new)
        post("/sessions/hub_identity", HubIdentityElixir.Phoenix.SessionController, :create)
      end
    end
  end
end
