defmodule HubIdentityElixir.HubIdentity.Server do
  @http Application.get_env(:hub_identity_elixir, :http) || HTTPoison

  def authenticate(params) do
    headers = [
      {"x-api-key", Application.get_env(:hub_identity_elixir, :public_key)},
      {"Content-Type", "application/json"}
    ]

    encoded = Jason.encode!(params)

    @http.post("#{base_url()}/api/v1/providers/hub_identity", encoded, headers)
    |> parse_response()
  end

  def get_certs() do
    @http.get("#{base_url()}/api/v1/oauth/certs", [])
    |> parse_response!()
  end

  def get_certs(key_id) do
    get_certs()
    |> Enum.find(fn %{"kid" => kid} -> kid == key_id end)
  end

  def get_providers do
    headers = [{"x-api-key", Application.get_env(:hub_identity_elixir, :public_key)}]

    @http.get("#{base_url()}/api/v1/providers", headers)
    |> parse_response()
  end

  def base_url do
    case Application.get_env(:hub_identity_elixir, :url) do
      url when is_binary(url) -> url
      _ -> "https://stage-identity.hubsynch.com"
    end
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 400, body: message}}) do
    {:error, message}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Jason.decode()
  end

  defp parse_response!({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Jason.decode!()
  end
end
