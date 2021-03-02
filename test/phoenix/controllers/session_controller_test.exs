defmodule HubIdentityElixir.Phoenix.Controllers.SessionControllerTest do
  use HubIdentityElixir.ConnCase

  describe "new/2" do
    test "returns the providers and layout", %{conn: conn} do
      response = get(conn, Routes.session_path(conn, :new)) |> html_response(200)
      assert response =~ "facebook"
      assert response =~ "google"
      assert response =~ "email"
      assert response =~ "password"
    end
  end

  describe "create/2" do
    test "with valid email and password assigns current_user", %{conn: conn} do
      response_conn =
        post(conn, Routes.session_path(conn, :create), %{
          email: "erin@hivelocity.co.jp",
          password: "password"
        })

      assert redirected_to(response_conn) == "/"
    end

    test "with invalid email and password returns error", %{conn: conn} do
      response_conn =
        post(conn, Routes.session_path(conn, :create), %{
          email: "nope@archer.com",
          password: "badpassword"
        })

      assert redirected_to(response_conn) == "/sessions/new"
    end
  end

  describe "delete/2" do
    test "logs a user out and returns to root path", %{conn: conn} do
      auth_conn =
        post(conn, Routes.session_path(conn, :create), %{
          email: "erin@hivelocity.co.jp",
          password: "password"
        })

      logged_out = delete(auth_conn, Routes.session_path(conn, :delete))
      assert get_session(logged_out, :current_user) == nil
      assert redirected_to(logged_out) == "/"
    end
  end
end
