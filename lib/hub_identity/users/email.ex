defmodule HubIdentityElixir.HubIdentity.Users.Email do
  alias HubIdentityElixir.HubIdentity.Server

  def create(user_uid, address) do
    Server.post("/users/#{user_uid}/emails", %{email: %{address: address}})
  end

  def get(user_uid) do
    Server.get("/users/#{user_uid}/emails")
  end

  def delete(user_uid, email_uid) do
    Server.delete("/users/#{user_uid}/emails/#{email_uid}")
  end
end
