defmodule HubIdentityElixir.ErrorView do
  use Phoenix.View,
    root: "lib/phoenix/templates",
    namespace: HubIdentityElixir

  # Use all HTML functionality (forms, tags, etc)
  use Phoenix.HTML

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
