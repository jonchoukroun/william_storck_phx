defmodule WilliamStorckPhxWeb.Admin.PaintingControllerTest do
  use WilliamStorckPhxWeb.ConnCase

  alias WilliamStorckPhx.{Admin, Auth}
  alias WilliamStorckPhxWeb.Router.Helpers, as: Routes

  @admin_attrs %{email: "admin@aol.com", name: "admin", password: "password"}
  @create_attrs %{
    name: "sandwich",
    material: "ham on rye",
    painting_height: 200,
    painting_width: 300,
    status: "available",
    price: 42,
    image_file: %Plug.Upload{
      path: "test/fixtures/test-image.jpg",
      filename: "test-image.jpg"
    }
  }
  @update_attrs %{
    name: "new sandwich",
    material: "turkey on wheat",
    painting_height: 400,
    painting_width: 800,
    status: "sold",
    price: nil,
    image_file: %Plug.Upload{
      path: "test/fixtures/test-image.jpg",
      filename: "test-image.jpg"
    }
  }
  @invalid_attrs %{
    name: nil,
    material: nil,
    painting_height: nil,
    painting_width: nil,
    status: nil,
    price: nil,
    image_file: nil
  }

  def fixture(:painting) do
    {:ok, painting} = Admin.create_painting(@create_attrs)
    painting
  end

  def fixture(:admin), do: Auth.create_user(@admin_attrs)

  describe "when not logged in" do
    test "redirects to login", %{conn: conn} do
      conn = get(conn, Routes.admin_painting_path(conn, :index))
      assert html_response(conn, 302)
    end
  end

  describe "index" do
    setup [:sign_in_admin, :create_painting]

    test "lists all paintings", %{conn: conn} do
      conn = get(conn, Routes.admin_painting_path(conn, :index))
      assert html_response(conn, 200)
    end
  end

  describe "new painting" do
    setup [:sign_in_admin, :create_painting]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_painting_path(conn, :new))
      assert html_response(conn, 200)
    end
  end

  describe "create painting" do
    setup [:sign_in_admin, :create_painting]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_painting_path(conn, :create), painting: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_painting_path(conn, :show, id)

      conn = get(conn, Routes.admin_painting_path(conn, :show, id))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_painting_path(conn, :create), painting: @invalid_attrs)
      assert html_response(conn, 200)
    end
  end

  describe "edit painting" do
    setup [:sign_in_admin, :create_painting]

    test "renders form for editing chosen painting", %{conn: conn, painting: painting} do
      conn = get(conn, Routes.admin_painting_path(conn, :edit, painting))
      assert html_response(conn, 200)
    end
  end

  describe "update painting" do
    setup [:sign_in_admin, :create_painting]

    test "redirects when data is valid", %{conn: conn, painting: painting} do
      conn = put(conn, Routes.admin_painting_path(conn, :update, painting), painting: @update_attrs)
      assert redirected_to(conn) == Routes.admin_painting_path(conn, :show, painting)

      conn = get(conn, Routes.admin_painting_path(conn, :show, painting))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, painting: painting} do
      conn = put(conn, Routes.admin_painting_path(conn, :update, painting), painting: @invalid_attrs)
      assert html_response(conn, 200)
    end
  end

  describe "delete painting" do
    setup [:sign_in_admin, :create_painting]

    test "deletes chosen painting", %{conn: conn, painting: painting} do
      conn = delete(conn, Routes.admin_painting_path(conn, :delete, painting))
      assert redirected_to(conn) == Routes.admin_painting_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.admin_painting_path(conn, :show, painting))
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

  defp create_painting(_) do
    painting = fixture(:painting)
    {:ok, painting: painting}
  end
end
