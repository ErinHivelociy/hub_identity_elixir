defmodule HubIdentityElixir.HubIdentity do
  @moduledoc """
  Documentation for `HubIdentityElixir`.
  """

  alias HubIdentityElixir.HubIdentity.{Server, Token}

  @doc """
  Authenticate with HubIdentity using an email and password.

  """

  def authenticate(params) do
    Server.authenticate(params)
  end

  @doc """
  Get the list of Open Authentication Providers from HubIdentity

  ## Examples

      iex> HubIdentityElixir.get_providers()
      [
          {
              "logo_url": "https://stage-identity.hubsynch.com/images/facebook.png",
              "name": "facebook",
              "request_url": request_url
          }
      ]
  """
  def get_providers do
    Server.get_providers()
  end

  def hub_identity_url do
    Server.base_url()
  end

  def build_current_user(%{"access_token" => access_token, "refresh_token" => refresh_token}) do
    with {:ok, user_params} <- Token.validate_token(access_token) do
      current_user = Map.put(user_params, :refresh_token, refresh_token)
      {:ok, current_user}
    end
  end

  def build_current_user(%{"access_token" => access_token}) do
    with {:ok, current_user} <- Token.validate_token(access_token) do
      {:ok, current_user}
    end
  end
end
