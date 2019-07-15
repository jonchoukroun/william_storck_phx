defmodule WilliamStorckPhx.AdminTest do
  use WilliamStorckPhx.DataCase

  alias WilliamStorckPhx.Admin

  describe "paintings" do
    alias WilliamStorckPhx.Painting

    @valid_attrs %{
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
      price: nil
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

    def painting_fixture(attrs \\ %{}) do
      {:ok, painting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_painting()

      painting
    end

    test "list_paintings/0 returns all paintings" do
      painting = painting_fixture()
      assert Admin.list_paintings() == [painting]
    end

    test "get_painting!/1 returns the painting with given id" do
      painting = painting_fixture()
      assert Admin.get_painting!(painting.id) == painting
    end

    test "create_painting/1 with valid data creates a painting" do
      assert {:ok, %Painting{} = painting} = Admin.create_painting(@valid_attrs)
      assert painting.name == @valid_attrs.name
      assert painting.material == @valid_attrs.material
      assert painting.price == @valid_attrs.price
      assert painting.status == @valid_attrs.status
      assert painting.size ==
        "#{@valid_attrs.painting_height}\" x #{@valid_attrs.painting_width}\""
      assert painting.src
      assert painting.slug
    end

    test "create_painting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_painting(@invalid_attrs)
    end

    test "update_painting/2 with valid data updates the painting" do
      painting = painting_fixture()
      assert {:ok, %Painting{} = painting} = Admin.update_painting(painting, @update_attrs)
      assert painting.name == @update_attrs.name
      assert painting.material == @update_attrs.material
      assert painting.price == @update_attrs.price
      assert painting.status == @update_attrs.status
      assert painting.size ==
        "#{@update_attrs.painting_height}\" x #{@update_attrs.painting_width}\""
      assert painting.src
      assert painting.slug
    end

    test "delete_painting/1 deletes the painting" do
      painting = painting_fixture()
      assert {:ok, %Painting{}} = Admin.delete_painting(painting)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_painting!(painting.id) end
    end

    test "change_painting/1 returns a painting changeset" do
      painting = painting_fixture()
      assert %Ecto.Changeset{} = Admin.change_painting(painting)
    end
  end

  describe "categories" do
    alias WilliamStorckPhx.Admin.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Admin.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Admin.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Admin.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Admin.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_category(category, @invalid_attrs)
      assert category == Admin.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Admin.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Admin.change_category(category)
    end
  end
end
