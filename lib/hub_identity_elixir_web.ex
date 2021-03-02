defmodule HubIdentityElixirWeb do
  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/phoenix/templates",
        namespace: HubIdentityElixirWeb

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import HubIdentityElixir.Phoenix.ErrorHelpers
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
