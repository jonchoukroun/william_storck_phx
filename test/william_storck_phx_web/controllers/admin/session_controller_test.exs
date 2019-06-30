defmodule WilliamStorckPhxWeb.Admin.SessionControllerTest do
  use WilliamStorckPhxWeb.ConnCase

  alias WilliamStorckPhxWeb.Admin

  @create_attrs %{email: "some email", is_active: true, password: "some password"}
  @invalid_attrs %{email: nil, is_active: nil, password: nil}

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, admin_session_path(conn, :new))
      assert html_response(conn, 200) =~ "New Session"
    end
  end

  describe "create session" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, admin_session_path(conn, :create), session: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == admin_session_path(conn, :show, id)

      conn = get(conn, admin_session_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Session"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, admin_session_path(conn, :create), session: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Session"
    end
  end

  describe "delete session" do
    test "deletes chosen session", %{conn: conn} do
      conn = delete(conn, admin_session_path(conn, :delete), session: get_session(conn, :current_user_id))
      assert redirected_to(conn) == admin_user_path(conn, :index)
    end
  end
end
