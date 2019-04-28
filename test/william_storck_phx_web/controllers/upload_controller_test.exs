defmodule WilliamStorckPhxWeb.PageControllerTest do
  use WilliamStorckPhxWeb.ConnCase

  alias WilliamStorckPhx.{Painting, Repo}

  describe "create/2" do
    @invalid_params %{}
    @valid_params %{
      name: "test_painting",
      material: "oil on rye",
      painting_height: 200,
      painting_width: 300,
      year: 2001,
      status: "availabled",
      price: 3000,
      image_file: %Plug.Upload{
        path: "test/fixtures/test-image.jpg",
        filename: "test-image.jpg"
      }
    }

    test "with invalid params returns error", %{conn: conn} do
      conn = post conn, "/upload", [painting: @invalid_params]

      assert get_flash(conn, :error) == "Some fields are missing below."

      assert Repo.all(Painting) |> Enum.count === 0
    end

    test "with valid params creates painting and signals success", %{conn: conn} do
      conn = post conn, "/upload", [painting: @valid_params]

      assert get_flash(conn, :info) == "#{@valid_params.name} uploaded successfully. You can upload another painting now."

      assert Repo.all(Painting) |> Enum.count === 1

      painting = Repo.all(Painting) |> List.first
      assert painting.name === @valid_params.name
      assert painting.size ===
        "#{@valid_params.painting_height}\" x #{@valid_params.painting_width}\""
    end

  end
end
