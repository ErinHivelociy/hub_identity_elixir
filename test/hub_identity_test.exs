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

  describe "parse_token/1" do
    test "returns user params from claims when token is valid" do
      tokens = HubIdentityElixir.MockServer.tokens()

      assert {:ok, user_params} =
               HubIdentity.parse_token(%{"access_token" => tokens[:access_token]})

      assert user_params[:uid] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert user_params[:user_type] == "Identities.User"

      assert {:ok, user_params} = HubIdentity.parse_token(tokens)
      assert user_params[:uid] == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert user_params[:user_type] == "Identities.User"
    end

    test "returns error when fails" do
      token =
        "eyJraWQiOiJvNFhRbVNLTHlLN1I0ejhDUWRLaVNDQVQ4ZmhnWFlNVWRLUUlUU0Rra2xJIiwiYWxnIjoiUlMyNTYiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL3N0YWdlLWlkZW50aXR5Lmh1YnN5bmNoLmNvbSIsImVtYWlsIjoibm90X2VyaW5AaGl2ZWxvY2l0eS5jby5qcCIsImV4cCI6MTYxNDY1NTQzNSwiaWF0IjoxNjE0NjUxODM1LCJpc3MiOiJIdWJJZGVudGl0eSIsImp0aSI6Ijk0NWZiODk0LTJjYTYtNGQ4Ni1hMTYzLThkZTdhOTNkMTYzYSIsIm5iZiI6MTYxNDY1MTgzNCwib3duZXJfdHlwZSI6bnVsbCwib3duZXJfdWlkIjpudWxsLCJzdWIiOiJJZGVudGl0aWVzLlVzZXI6MzgwNTQ5ZDEtY2Y5YS00YmNiLWI2NzEtYTI2NjdlOGQyMzAxIiwidHlwIjoiYWNjZXNzIiwidWlkIjoiMzgwNTQ5ZDEtY2Y5YS00YmNiLWI2NzEtYTI2NjdlOGQyMzAxIn0.nesXK09oqUIYZWNdphzcA4IbXGaOlMUd_dH_NjprRspBrlNhq4P78ou62bVcBu5vmL3kSqEwXsGDnjJTSApPRn8XvojmC72QG8_Ld2uv3n13alQmTFckq50sLRzqrzJad_oYTpZsjVi2yoHK35H_2BLwKQk5GpkKV6UIB8y7KntsLOZvS1RC5bwIP1paqTP-_bT3N1UnDeWDZkUL-vlfNTinMutOqz_GQGR1wVim4hJ7mEauDgyZxUJR5GiLdTXGLo4-0I1MDfuI3j4CLCvgt1YFgKikfiONZFzFL6vlJY0MwAU6ytGvJKJ1EZqozs4rbhBnLMpe6wCIglvITAXlSw"

      assert {:error, :signature_fail} == HubIdentity.parse_token(%{"access_token" => token})
    end
  end

  describe "get_user_emails/1" do
    test "Get list of users emails" do
      {:ok, emails} = HubIdentity.get_user_emails("user_uid")

      assert is_list(emails)
      assert length(emails) == 2
    end
  end

  describe "add_new_email/2" do
    test "Add a new user email" do
      {:ok, email} = HubIdentity.add_user_email("hub_identity", "test@gmail.com")

      assert email["address"] ==  "test@gmail.com"
      assert email["primary"] == false
    end
  end

  describe "remove_user_email/2" do
    test "Removes a user email" do
      {:ok, response} = HubIdentity.remove_user_email("hub_identity", "test@gmail.com")

      assert response ==  "successful operation"
    end
  end

  describe "send_verification/2" do
    test "Sends a verification code to the users primary email" do
      {:ok, response} = HubIdentity.send_verification("hub_identity", "reference")
      assert response ==  "successful operation"
    end
  end

  describe "validate_verification_code/2" do
    test "Validates the code and returns success" do
      {:ok, response} = HubIdentity.validate_verification_code("hub_identity", "reference", 1122)

      assert response ==  "verification success"
    end

    test "Returns verification failed with wrong code" do
      wrong_code = 7777
      {:error, response} = HubIdentity.validate_verification_code("hub_identity", "reference", wrong_code)

      assert response ==  "{\"error\":\"verification failed\"}"
    end

    test "Returns bad request code with invalid code" do
      assert {:error, "bad request"} == HubIdentity.validate_verification_code("hub_identity", "reference", "invalid code")
    end
  end

  describe "renew_verification_code/2" do
    test "Updates the reference for a verification and sends a new code to the users email" do
      {:ok, response} = HubIdentity.renew_verification_code("hub_identity", "old_reference", "new_reference")

      assert response ==  "successful operation"
    end
  end
end
