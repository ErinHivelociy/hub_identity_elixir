defmodule HubIdentityElixir.HubIdentity.Server do
  @http Application.get_env(:hub_identity_elixir, :http) || HTTPoison

  def authenticate(params) do
    @http.post(
      "#{base_url()}/api/v1/providers/hub_identity",
      Jason.encode!(params),
      public_headers()
    )
    |> parse_response()
  end

  def get_certs do
    @http.get("#{base_url()}/api/v1/oauth/certs", [])
    |> parse_response!()
  end

  def get_providers do
    @http.get("#{base_url()}/api/v1/providers", public_headers())
    |> parse_response()
  end

  def base_url do
    case Application.get_env(:hub_identity_elixir, :url) do
      url when is_binary(url) -> url
      _ -> "http://localhost:4000"
    end
  end

  defp public_headers do
    [
      {"x-api-key", Application.get_env(:hub_identity_elixir, :public_key)},
      {"Content-Type", "application/json"}
    ]
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 400, body: message}}),
    do: {:error, message}

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Jason.decode()
  end

  defp parse_response!({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Jason.decode!()
  end
end
