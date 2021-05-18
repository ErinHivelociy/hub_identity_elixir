defmodule HubIdentityElixir.Phoenix.Router do
  @moduledoc false
  use Phoenix.Router

  defmacro __using__(_opts \\ []) do
    quote do
      import HubIdentityElixir.Authentication,
        only: [
          fetch_current_user: 2,
          require_authenticated_user: 2
        ]

      import unquote(__MODULE__),
        only: [hub_identity_routes: 0]
    end
  end

  defmacro hub_identity_routes do
    quote do
      scope "/hub_identity", alias: false, as: false do
        delete("/sessions/destroy", HubIdentityElixir.Phoenix.SessionController, :destroy)
        get("/sessions/new", HubIdentityElixir.Phoenix.SessionController, :new)
        get("/sessions/create", HubIdentityElixir.Phoenix.SessionController, :create)
      end
    end
  end
end
