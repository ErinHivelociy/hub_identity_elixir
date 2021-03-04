defmodule HubIdentityElixir.HubIdentityTest do
  use ExUnit.Case

  alias HubIdentityElixir.HubIdentity

  describe "authenticate/1" do
    test "returns the decoded body when successful" do
      params = %{email: "erin@hivelocity.co.jp", password: "password"}
      assert {:ok, tokens} = HubIdentity.authenticate(params)
      assert tokens["access_token"] != nil
      assert tokens["refresh_token"] != nil
    end

    test "returns error when authentication fails" do
      params = %{email: "nope@archer.com", password: "password"}
      assert {:error, "bad request"} == HubIdentity.authenticate(params)
    end
  end

  describe "get_certs/0" do
    test "returns current public key certs" do
      certs = HubIdentity.get_certs()
      assert 2 == length(certs)
    end
  end

  describe "get_certs/1" do
    test "returns the public key cert with the kid" do
      cert = HubIdentity.get_certs("Z6s25OvX-NulYhm1iKwRX6jkU2AdpOIvNZvYy3WW-oE")
      assert cert["kid"] == "Z6s25OvX-NulYhm1iKwRX6jkU2AdpOIvNZvYy3WW-oE"
    end

    test "returns nil if no cert matches the kid" do
      assert nil == HubIdentity.get_certs("RX6jkU2AdpOIvNZvYy3WW-oEZ6s25OvX-NulYhm1iKw")
    end
  end

  describe "get_providers/0" do
    test "returns current list of providers" do
      assert {:ok, providers} = HubIdentity.get_providers()
      assert 2 == length(providers)
    end
  end
end
