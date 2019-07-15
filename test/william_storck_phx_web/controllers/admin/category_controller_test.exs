defmodule WilliamStorckPhxWeb.Admin.CategoryControllerTest do
  use WilliamStorckPhxWeb.ConnCase

  alias WilliamStorckPhx.{Admin, Auth}
  alias WilliamStorckPhxWeb.Router.Helpers, as: Routes

  @admin_attrs %{email: "admin@aol.com", name: "admin", password: "xxxxxx"}
  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:category) do
    {:ok, category} = Admin.create_category(@create_attrs)
    category
  end

  def fixture(:admin) do
    {:ok, admin} = Auth.create_user(@admin_attrs)
    admin
  end

  describe "when not logged in" do
    test "redirects to login", %{conn: conn} do
      conn = get(conn, Routes.admin_category_path(conn, :index))
      assert html_response(conn, 302)
    end
  end

  describe "index" do
    setup [:sign_in_admin]

    test "lists all categories", %{conn: conn} do
      conn = get(conn, Routes.admin_category_path(conn, :index))
      assert html_response(conn, 200)
    end
  end

  describe "new category" do
    setup [:sign_in_admin]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_category_path(conn, :new))
      assert html_response(conn, 200)
    end
  end

  describe "create category" do
    setup [:sign_in_admin]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_category_path(conn, :create), category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_category_path(conn, :show, id)

      conn = get(conn, Routes.admin_category_path(conn, :show, id))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_category_path(conn, :create), category: @invalid_attrs)
      assert html_response(conn, 200)
    end
  end

  describe "edit category" do
    setup [:sign_in_admin, :create_category]

    test "renders form for editing chosen category", %{conn: conn, category: category} do
      conn = get(conn, Routes.admin_category_path(conn, :edit, category))
      assert html_response(conn, 200)
    end
  end

  describe "update category" do
    setup [:sign_in_admin, :create_category]

    test "redirects when data is valid", %{conn: conn, category: category} do
      conn = put(conn, Routes.admin_category_path(conn, :update, category), category: @update_attrs)
      assert redirected_to(conn) == Routes.admin_category_path(conn, :show, category)

      conn = get(conn, Routes.admin_category_path(conn, :show, category))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      conn = put(conn, Routes.admin_category_path(conn, :update, category), category: @invalid_attrs)
      assert html_response(conn, 200)
    end
  end

  describe "delete category" do
    setup [:sign_in_admin, :create_category]

    test "deletes chosen category", %{conn: conn, category: category} do
      conn = delete(conn, Routes.admin_category_path(conn, :delete, category))
      assert redirected_to(conn) == Routes.admin_category_path(conn, :index)
    end
  end

  defp sign_in_admin(_) do
    fixture(:admin)

    conn = build_conn(:get, "/")
    conn = post(conn,
      Routes.admin_session_path(conn, :create),
      session: %{email: @admin_attrs.email, password: @admin_attrs.password})

    {:ok, conn: conn}
  end

  defp create_category(_) do
    category = fixture(:category)
    {:ok, category: category}
  end
end
