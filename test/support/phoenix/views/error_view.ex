defmodule HubIdentityElixir.ErrorView do
  use Phoenix.View,
    root: "lib/phoenix/templates",
    namespace: HubIdentityElixir

  # Use all HTML functionality (forms, tags, etc)
  use Phoenix.HTML

  # Import basic rendering functionality (render, render_layout, etc)
  import Phoenix.View

  import HubIdentityElixir.TestErrorHelpers

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
