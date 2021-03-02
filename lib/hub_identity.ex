defmodule HubIdentityElixir.HubIdentity do
  @moduledoc """
  Documentation for `HubIdentityElixir`.
  """

  alias HubIdentityElixir.HubIdentity.{Server, Token}

  @doc """
  Authenticate with HubIdentity using an email and password. This will call the HubIdentity
  server and try to autheniticate.
  Use this method for users who authenticate directly with HubIdentity.

  ## Examples

      iex> HubIdentityElixir.authenticate(%{email: "erin@hivelocity.co.jp", password: "password"})
      {:ok, %{"access_token" => access_token, "refresh_token" => refresh_token}}

      iex> HubIdentityElixir.authenticate(%{email: "erin@hivelocity.co.jp", password: "wrong"})
      {:error, "bad request"}

  """

  def authenticate(params) do
    Server.authenticate(params)
  end

  @doc """
  Get the list of Open Authentication Providers from HubIdentity.
  Remember these links are only good once, and one link. If a users authenticates
  with Google then the facebook link will be invalid.
  The links also expire with 10 minutes of issue.

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
    with {:ok, user_params} <- Token.parse(access_token) do
      current_user = Map.put(user_params, :refresh_token, refresh_token)
      {:ok, current_user}
    end
  end

  def build_current_user(%{"access_token" => access_token}) do
    with {:ok, current_user} <- Token.parse(access_token) do
      {:ok, current_user}
    end
  end
end
