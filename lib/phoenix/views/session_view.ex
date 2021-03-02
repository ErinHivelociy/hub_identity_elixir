defmodule HubIdentityElixir.Phoenix.SessionView do
  # @moduledoc false
  # Use all HTML functionality (forms, tags, etc)
  use Phoenix.HTML

  use Phoenix.View,
    root: "lib/phoenix/templates",
    namespace: HubIdentityElixir

  # Import basic rendering functionality (render, render_layout, etc)
  import Phoenix.View
  import HubIdentityElixir.Phoenix.ErrorHelpers

  def provider_link_helper(provider) do
    provider["logo_url"]
    |> img_tag(alt: "#{provider["name"]} authentication link", width: "380")
    |> link(to: provider["request_url"])
  end

  def route_helper(%Plug.Conn{private: %{phoenix_endpoint: endpoint}} = conn, path, method) do
    base = Module.split(endpoint) |> hd()
    module = String.to_existing_atom("Elixir.#{base}.Router.Helpers")
    apply(module, path, [conn, method])
  end
end
