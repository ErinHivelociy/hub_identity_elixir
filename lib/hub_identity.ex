defmodule HubIdentityElixir.HubIdentity do
  @moduledoc """
  Documentation for `HubIdentityElixir`.
  """

  alias HubIdentityElixir.HubIdentity.{Server, Token}

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

  def parse_tokens(%{"access_token" => access_token, "refresh_token" => refresh_token}) do
    with {:ok, session_params} <- Token.validate_token(access_token) do
      {:ok, session_params, refresh_token}
    end
  end
end
