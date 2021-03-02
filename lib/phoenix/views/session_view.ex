defmodule HubIdentityElixir.Phoenix.SessionView do
  # @moduledoc false
  use HubIdentityElixirWeb, :view

  def provider_link_helper(provider) do
    provider["logo_url"]
    |> img_tag(alt: "#{provider["name"]} authentication link", width: "380")
    |> link(to: provider["request_url"])
  end

  def route_helper(%Plug.Conn{private: %{phoenix_router: router}} = conn, path, method) do
    module = String.to_existing_atom("#{router}.Helpers")
    apply(module, path, [conn, method])
  end
end
