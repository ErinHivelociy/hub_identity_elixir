defmodule HubIdentityElixir.HubIdentity do
  @moduledoc """
  An Elixir Package designed to make implementing HubIdentity authentication easy and fast.
  In order to use this package you need to have an account with [HubIdentity](https://stage-identity.hubsynch.com/)

  Currently this is only for [Hivelocity](https://www.hivelocity.co.jp/) uses. If you have a
  commercial interest please contact the Package Manager Erin Boeger through linkedIn or Github or
  through [Hivelocity](https://www.hivelocity.co.jp/contact/).
  """

  alias HubIdentityElixir.HubIdentity.Users.{Email, Verification}
  alias HubIdentityElixir.HubIdentity.{Server, Token}

  @doc """
  Authenticate with HubIdentity using an email and password. This will call the HubIdentity
  server and try to autheniticate.
  Use this method for users who authenticate directly with HubIdentity.
  Upon successful email and password

  ## Examples

      iex> HubIdentityElixir.HubIdentity.authenticate(%{email: "erin@hivelocity.co.jp", password: "password"})
      {:ok, %{"access_token" => access_token, "refresh_token" => refresh_token}}

      iex> HubIdentityElixir.HubIdentity.authenticate(%{email: "erin@hivelocity.co.jp", password: "wrong"})
      {:error, "bad request"}

  """

  def authenticate(params), do: Server.authenticate(params)

  @doc """
  Get the current servers public key certificates. These certificates are used to verify a HubIdentity
  issued JWT signature. These certificates are rotated on a regular basis. If your website has significant
  activity, it may make sense to cache and refresh when they expire.
  Each certificate returned has a timestamp of when the certificate will expire.

  ## Examples

      iex> HubIdentityElixir.HubIdentity.get_certs()
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

      iex> HubIdentityElixir.HubIdentity.get_certs("C8Rn3J8tPlMp8etztCsb4k51sjTFXbA-Til9XptF2FM")
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

  def get_current_user(cookie_id), do: Server.get_current_user(cookie_id)

  @doc """
  Parse and validate a JWT from HubIdentity.
  When successful will return an ok tuple with a current_user map.

  ## Examples

      iex> HubIdentityElixir.HubIdentity.parse_token(%{"access_token" => access JWT})
      {:ok, %{
          uid: "hub_identity_uid_1234",
          user_type: "HubIdentity.User"
        }
      }

      iex> HubIdentityElixir.HubIdentity.parse_token(%{"access_token" => invalid JWT})
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

      iex> HubIdentityElixir.HubIdentity.get_providers()
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

  @doc """
  Get the list of a users emails from HubIdentity.

  ## Examples

      iex> HubIdentityElixir.HubIdentity.get_user_emails(user_uid)
      {:ok,
      [
        %{
          "Object" => "Email",
          "address" => "test@hivelocity.co.jp",
          "confirmed_at" => "2021-04-07T02:52:31Z",
          "primary" => true,
          "uid" => "81b7d2ef-43ef-42f8-922d-62602eac518a"
        },
        %{
          "Object" => "Email",
          "address" => "test2@hivelocity.co.jp",
          "confirmed_at" => "2021-06-03T07:59:55Z",
          "primary" => false,
          "uid" => "8c8c09a7-b500-430c-a45c-569bd9fa5a08"
        }
      ]}
  """
  def get_user_emails(user_uid) do
    Email.get(user_uid)
  end
@doc """
  Sends an email confirmation to the email address to add a new users email.

  ## Examples

      iex> HubIdentityElixir.HubIdentity.add_user_email(user_uid, address)
      {:ok, %HTTPoison{body: "{\"success\":\"email verification request sent\"}"}}
  """
  def add_user_email(user_uid, address) do
    Email.create(user_uid, address)
  end

  @doc """
  Remove a users email.

  ## Examples

      iex> HubIdentityElixir.HubIdentity.remove_user_email(user_uid, email_uid)
      {:ok, %HTTPoison{body: "{\"success\":\"email email_uid deleted\"}"}}
  """
  def remove_user_email(user_uid, email_uid) do
    Email.delete(user_uid, email_uid)
  end

  @doc """
  Sends an email verification code to the email address.

  Reference length must be between 22 and 44 characters
  ## Examples

      iex> HubIdentityElixir.HubIdentity.send_verification(user_uid, reference)
      {:ok, %HTTPoison{body: "successful operation"}}
  """
  def send_verification(user_uid, reference) do
    Verification.create(user_uid, reference)
  end
@doc """
  Verify the code and reference to validate the user.
  You have 3 attemps.
  ## Examples
      iex> HubIdentityElixir.HubIdentity.validate_verification_code(user_uid, reference, valid_code)
        {:ok, %{"ok" => "verification success"}}

      iex> HubIdentityElixir.HubIdentity.validate_verification_code(user_uid, reference, wrong_code)
        {:error, "{\"error\":\"verification failed\"}"}

      iex> HubIdentityElixir.HubIdentity.validate_verification_code(user_uid, reference, 3rd_attemp_code)
        {:error, "{\"error\":\"max attempts reached\"}"}
  """
  def validate_verification_code(user_uid, reference, code) do
    Verification.validate(user_uid, reference, code)
  end
@doc """
  Renew the reference and sends a new verification code to the user.

  ## Examples

      iex> HubIdentityElixir.HubIdentity.renew_verification_code(user_uid, old_reference, new_reference)
      {:ok, %HTTPoison{body: "successful operation"}}
  """
  def renew_verification_code(user_uid, old_reference, new_reference) do
    Verification.renew(user_uid, old_reference, new_reference)
  end
end
