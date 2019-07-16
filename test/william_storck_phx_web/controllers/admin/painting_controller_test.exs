defmodule WilliamStorckPhxWeb.Admin.PaintingControllerTest do
  use WilliamStorckPhxWeb.ConnCase

  alias WilliamStorckPhx.{Admin, Auth}
  alias WilliamStorckPhxWeb.Router.Helpers, as: Routes

  @admin_attrs %{email: "admin@aol.com", name: "admin", password: "password"}
  @create_attrs %{
    name: "sandwich",
    category_id: nil,
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
    category_id: nil,
    material: "turkey on wheat",
    painting_height: 400,
    painting_width: 800,
    status: "sold",
    price: nil
  }
  @invalid_attrs %{
    name: nil,
    category_id: nil,
    material: nil,
    painting_height: nil,
    painting_width: nil,
    status: nil,
    price: nil,
    image_file: nil
  }

  def fixture(:painting, category_id) do
    {:ok, painting} = Admin.create_painting(%{@create_attrs | category_id: category_id})
    painting
  end

  def fixture(:category) do
    {:ok, category} = Admin.create_category(%{name: "metal"})
    category
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
    setup [:sign_in_admin, :create_category]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.admin_painting_path(conn, :create), painting: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_painting_path(conn, :show, id)

      conn = get(conn, Routes.admin_painting_path(conn, :show, id))
      assert html_response(conn, 200)

      painting = Admin.get_painting!(id)
      assert painting.name == @create_attrs.name
      assert painting.material == @create_attrs.material
      assert painting.status == @create_attrs.status
      assert painting.price == @create_attrs.price
      assert painting.size ==
        "#{@create_attrs.painting_height}\" x #{@create_attrs.painting_width}\""
      refute painting.category_id
      refute painting.category
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

  defp sign_in_admin(_) do
    fixture(:admin)

    conn = build_conn(:get, "/")
    conn = post(conn,
      Routes.admin_session_path(conn, :create),
      session: %{email: @admin_attrs.email, password: @admin_attrs.password})

    {:ok, conn: conn}
  end

  defp create_painting(_) do
    category = fixture(:category)
    painting = fixture(:painting, category.id)
    {:ok, painting: painting}
  end

  defp create_category(context) do
    category = fixture(:category)
    assigns = Map.put(context.conn.assigns, :categories, [category])
    {:ok, conn: %{context.conn | assigns: assigns}}
  end
end
