defmodule HubIdentityElixir.HubIdentity do
  @moduledoc """
  Documentation for `HubIdentityElixir`.
  """

  alias HubIdentityElixir.HubIdentity.{Server, Token}

  @doc """
  Authenticate with HubIdentity using an email and password. This will call the HubIdentity
  server and try to autheniticate.
  Use this method for users who authenticate directly with HubIdentity.
  Upon successful email and password

  ## Examples

      iex> HubIdentityElixir.authenticate(%{email: "erin@hivelocity.co.jp", password: "password"})
      {:ok, %{"access_token" => access_token, "refresh_token" => refresh_token}}

      iex> HubIdentityElixir.authenticate(%{email: "erin@hivelocity.co.jp", password: "wrong"})
      {:error, "bad request"}

  """

  def authenticate(params), do: Server.authenticate(params)

  @doc """
  Get the current servers public key certificates. These certificates are used to verify a HubIdentity
  issued JWT signature. These certificates are rotated on a regular basis. If your website has significant
  activity, it may make sense to cache and refresh when they expire.
  Each certificate returned has a timestamp of when the certificate will expire.

  ## Examples

      iex> HubIdentityElixir.get_certs()
      [
          {
              "alg": "RS256",
              "e": "AQAB",
              "expires": 1614837416,
              "kid": "C8Rn3J8tPlMp8etztCsb4k51sjTFXbA-Til9XptF2FM",
              "kty": "RSA",
              "n": "really long n",
              "use": "sig"
          },
          ...
      ]

  """
  def get_certs, do: Server.get_certs()

  @doc """
  Get a certificate by a kid. The kid is included with every HubIdentity issued JWT and
  idetnitifies which certificate was used to generate the certificate.

  ## Examples

      iex> HubIdentityElixir.get_certs("C8Rn3J8tPlMp8etztCsb4k51sjTFXbA-Til9XptF2FM")
        {
            "alg": "RS256",
            "e": "AQAB",
            "expires": 1614837416,
            "kid": "C8Rn3J8tPlMp8etztCsb4k51sjTFXbA-Til9XptF2FM",
            "kty": "RSA",
            "n": "really long n",
            "use": "sig"
        }

      iex> HubIdentityElixir.get_certs("expired or not valid kid")
      nil
  """

  def get_certs(key_id) do
    get_certs()
    |> Enum.find(fn %{"kid" => kid} -> kid == key_id end)
  end

  @doc """
  Parse and validate a JWT from HubIdentity.
  When successful will return an ok tuple with a current_user map.

  ## Examples

      iex> HubIdentityElixir.parse_token(%{"access_token" => access JWT})
      {:ok, %{
          owner_type: "Hubsynch.User",
          owner_uid: "uid_1234",
          uid: "hub_identity_uid_1234",
          user_type: "HubIdentity.User"
        }
      }

      iex> HubIdentityElixir.parse_token(%{"access_token" => invalid JWT})
      {:error, :claims_parse_fail}

  """
  def parse_token(%{"access_token" => access_token}), do: Token.parse(access_token)

  def parse_token(%{access_token: access_token}), do: Token.parse(access_token)

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
  def get_providers, do: Server.get_providers()

  def hub_identity_url, do: Server.base_url()

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
