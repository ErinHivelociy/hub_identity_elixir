defmodule HubIdentityElixir.Phoenix.Router do
  @doc false
  use Phoenix.Router

  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__),
        only: [hub_identity_routes: 0]
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
        get("/login", HubIdentityElixir.Phoenix.ProviderController, :providers)
        post("/login/hub_identity", HubIdentityElixir.Phoenix.ProviderController, :authenticate)
      end
    end
  end
end
