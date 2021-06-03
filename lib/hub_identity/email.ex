defmodule HubIdentityElixir.HubIdentity.Email do
  alias HubIdentityElixir.HubIdentity.Server

  def create(uid, address) do
    Server.post("/users/#{uid}/emails", %{email: %{address: address}})
  end

  def get(uid) do
    Server.get("/users/#{uid}/emails")
  end
end
