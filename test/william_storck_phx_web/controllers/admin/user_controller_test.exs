defmodule WilliamStorckPhxWeb.Admin.UserControllerTest do
  use WilliamStorckPhxWeb.ConnCase

  alias WilliamStorckPhx.Auth
  alias WilliamStorckPhxWeb.Router.Helpers, as: Routes

  @admin_attrs %{email: "admin@aol.com", name: "admin", password: "password"}
  @create_attrs %{
    email: "bob@aol.com",
    name: "bob",
    password: "xxxxxx",
    password_confirm: "xxxxxx"
  }
  @update_attrs %{
    email: "joe@hotmail.com",
    name: "joe",
    password: "yyyyyy"
  }
  @invalid_attrs %{email: nil, name: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@create_attrs)
    user
  end

  def fixture(:admin), do: Auth.create_user(@admin_attrs)

  describe "index" do
    setup [:sign_in_admin, :create_user]

    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :index))
      assert html_response(conn, 200)
    end
  end

  describe "new user" do
    setup [:sign_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :new))
      assert html_response(conn, 200)
    end
  end

  describe "create user" do
    setup [:sign_in_admin]

    test "renders changeset error when password is too short", %{conn: conn} do
      invalid_params = %{@create_attrs | password: "xxx", password_confirm: "xxx"}
      conn = post(conn, Routes.admin_user_path(conn, :create), user: invalid_params)

      assert conn.assigns[:changeset].errors |> Enum.count()
    end

    test "renders changeset error when passwords don't match", %{conn: conn} do
      invalid_params = %{@create_attrs | password: "zzzzzz"}
      conn = post(conn, Routes.admin_user_path(conn, :create), user: invalid_params)

      assert conn.assigns[:changeset].errors |> Enum.count()
    end

    test "renders changeset error when email is already taken", %{conn: conn} do
      invalid_params = %{@create_attrs | email: "admin@aol.com"}
      conn = post(conn, Routes.admin_user_path(conn, :create), user: invalid_params)

      assert conn.assigns[:changeset].errors |> Enum.count()
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_user_path(conn, :create), user: @invalid_attrs)
      assert conn.assigns[:error_message]
    end

    test "creates user and redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_user_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)

      new_user = Auth.find_user(:email, @create_attrs.email)
      assert new_user.name === @create_attrs.name
      assert new_user.email === @create_attrs.email
    end
  end

  describe "edit user" do
    setup [:sign_in_admin, :create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.admin_user_path(conn, :edit, user))
      assert html_response(conn, 200)
    end
  end

  describe "update user" do
    setup [:sign_in_admin, :create_user]

    test "updates user redirects to index when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.admin_user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)

      updated_user = Auth.get_user!(user.id)
      conn = get(conn, Routes.admin_user_path(conn, :index))
      assert html_response(conn, 200)
      assert updated_user.name === @update_attrs.name
      assert updated_user.email === @update_attrs.email
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.admin_user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200)
      assert conn.assigns[:changeset].errors |> Enum.count()
    end
  end

  describe "delete user" do
    setup [:sign_in_admin, :create_user]

    test "cannot delete logged in user", %{conn: conn} do
      admin_user = Auth.get_user!(get_session(conn, :current_user_id))
      conn = delete(conn, Routes.admin_user_path(conn, :delete, admin_user))
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)
      assert Auth.get_user!(admin_user.id)
    end

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.admin_user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.admin_user_path(conn, :index)
      assert_raise Ecto.NoResultsError, fn ->
        Auth.get_user!(user.id)
      end
    end
  end

  defp sign_in_admin(__) do
    fixture(:admin)

    conn = build_conn(:get, "/")
    conn = post(conn,
      Routes.admin_session_path(conn, :create),
      session: %{email: @admin_attrs.email, password: @admin_attrs.password})

    {:ok, conn: conn}
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
