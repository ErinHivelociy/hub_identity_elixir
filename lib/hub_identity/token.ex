defmodule HubIdentityElixir.HubIdentity.Token do
  alias HubIdentityElixir.HubIdentity.Server

  def validate_token(token) do
    with [header, claims, signature] <- String.split(token, ".") do
      {:ok, session_params} = build_session_params(claims)
      true = verify_signature({header, claims}, signature)
      {:ok, session_params}
    else
      false -> {:error, :signature_fail}
    end
  end

  defp base_jason_decode(string) do
    with {:ok, base_decoded} <- Base.url_decode64(string, padding: false),
         {:ok, jason_decoded} <- Jason.decode(base_decoded) do
      {:ok, jason_decoded}
    end
  end

  defp build_session_params(claims) do
    {:ok,
     %{
       "owner_type" => owner_type,
       "owner_uid" => owner_uid,
       "sub" => subject
     }} = base_jason_decode(claims)

    [user_type, uid] = String.split(subject, ":")
    {:ok, %{owner_type: owner_type, owner_uid: owner_uid, uid: uid, user_type: user_type}}
  end

  defp verify_signature({header, claims}, signature) do
    with {:ok, %{"kid" => key_id}} <- base_jason_decode(header),
         {:ok, decoded_signature} <- Base.url_decode64(signature, padding: false),
         %{"e" => encoded_e, "n" => encoded_n} <- Server.get_certs(key_id),
         {:ok, e} <- Base.url_decode64(encoded_e, padding: false),
         {:ok, n} <- Base.url_decode64(encoded_n, padding: false) do
      :crypto.verify(:rsa, :sha256, "#{header}.#{claims}", decoded_signature, [e, n])
    end
  end
end
