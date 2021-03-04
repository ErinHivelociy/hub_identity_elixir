defmodule HubIdentityElixir.Phoenix.Controllers.SessionControllerTest do
  use HubIdentityElixir.ConnCase

  describe "new/2" do
    test "redirects to HubIdentity", %{conn: conn} do
      new_conn = get(conn, Routes.session_path(conn, :new))
      assert redirected_to(new_conn) =~ "localhost/browser/v1/providers?api_key="
    end
  end

  describe "create/2" do
    test "with valid access_token assigns current_user", %{conn: conn} do
      new_conn =
        get(conn, Routes.session_path(conn, :create), HubIdentityElixir.MockServer.tokens())

      assert redirected_to(new_conn) == "/"
      current_user = get_session(new_conn, :current_user)

      assert current_user.uid == "380549d1-cf9a-4bcb-b671-a2667e8d2301"
      assert current_user.user_type == "Identities.User"
    end
  end

  describe "delete/2" do
    test "logs a user out and returns to root path", %{conn: conn} do
      new_conn =
        get(conn, Routes.session_path(conn, :create), HubIdentityElixir.MockServer.tokens())

      assert get_session(new_conn, :current_user) != nil

      logged_out = delete(conn, Routes.session_path(conn, :delete))

      assert redirected_to(logged_out) == "/"
      assert get_session(logged_out, :current_user) == nil
    end
  end
end
