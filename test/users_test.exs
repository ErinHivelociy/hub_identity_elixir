defmodule HubIdentityElixir.UsersTest do
  use ExUnit.Case

  alias HubIdentityElixir.Users

  describe "get_emails/1" do
    test "Get list of users emails" do
      {:ok, emails} = Users.get_emails("user_uid")

      assert is_list(emails)
      assert length(emails) == 2
    end
  end

  describe "add_email/2" do
    test "Add a new user email" do
      {:ok, email} = Users.add_email("hub_identity", "test@gmail.com")

      assert email["address"] == "test@gmail.com"
      assert email["primary"] == false
    end
  end

  describe "remove_email/2" do
    test "Removes a user email" do
      {:ok, response} = Users.remove_email("hub_identity", "test@gmail.com")

      assert response == "successful operation"
    end
  end

  describe "send_verification/2" do
    test "Sends a verification code to the users primary email" do
      {:ok, response} = Users.send_verification("hub_identity", "reference")
      assert response == "successful operation"
    end
  end

  describe "validate_verification_code/2" do
    test "Validates the code and returns success" do
      {:ok, response} = Users.validate_verification_code("hub_identity", "reference", 1122)

      assert response == "verification success"
    end

    test "Returns verification failed with wrong code" do
      wrong_code = 7777

      {:error, response} =
        Users.validate_verification_code("hub_identity", "reference", wrong_code)

      assert response == "{\"error\":\"verification failed\"}"
    end

    test "Returns bad request code with invalid code" do
      assert {:error, "bad request"} ==
               Users.validate_verification_code("hub_identity", "reference", "invalid code")
    end
  end

  describe "renew_verification_code/2" do
    test "Updates the reference for a verification and sends a new code to the users email" do
      {:ok, response} =
        Users.renew_verification_code("hub_identity", "old_reference", "new_reference")

      assert response == "successful operation"
    end
  end
end
