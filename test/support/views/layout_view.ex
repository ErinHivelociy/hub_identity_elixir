defmodule HubIdentityElixir.LayoutView do
  # @moduledoc false
  use Phoenix.View,
    root: "test/support/templates",
    namespace: HubIdentityElixirWeb

  # Use all HTML functionality (forms, tags, etc)
  use Phoenix.HTML

  # Import basic rendering functionality (render, render_layout, etc)
  import Phoenix.View

  import HubIdentityElixir.Phoenix.ErrorHelpers
end
