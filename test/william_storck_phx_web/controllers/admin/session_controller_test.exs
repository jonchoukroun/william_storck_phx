defmodule WilliamStorckPhxWeb.Admin.SessionControllerTest do
  use WilliamStorckPhxWeb.ConnCase

  alias WilliamStorckPhx.Auth

  @user_attrs %{email: "some email", name: "some name", password: "some password"}
  @valid_attrs %{email: @user_attrs.email, password: @user_attrs.password}
  @invalid_attrs %{email: nil, name: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@user_attrs)
    user
  end

  describe "create session" do
    test "creates session and redirects to admin when data is valid", %{conn: conn} do
      user = fixture(:user)

      conn = post(conn, admin_session_path(conn, :create), session: @valid_attrs)

      assert redirected_to(conn) == admin_landing_path(conn, :index)
      assert get_session(conn, :current_user_id) === user.id

      conn = get(conn, admin_user_path(conn, :index))
      assert conn.assigns[:current_user].id === user.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, admin_session_path(conn, :create), session: @invalid_attrs)
      assert conn.assigns[:error_message]
    end
  end

  describe "delete session" do
    setup [:sign_in_user]

    test "deletes chosen session", %{conn: conn, user: user} do
      assert get_session(conn, :current_user_id) === user.id

      conn = delete(conn, admin_session_path(conn, :delete))
      refute get_session(conn, :current_user_id)

      assert redirected_to(conn) === admin_session_path(conn, :new)
    end
  end

  defp sign_in_user(_) do
    user = fixture(:user)

    conn = build_conn(:get, "/admin")
    conn = post(conn, admin_session_path(conn, :create), session: @valid_attrs)

    {:ok, conn: conn, user: user}
  end
end
