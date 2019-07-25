defmodule WilliamStorckPhx.AdminTest do
  use WilliamStorckPhx.DataCase

  alias WilliamStorckPhx.Admin

  describe "paintings" do
    alias WilliamStorckPhx.Painting

    @valid_attrs %{
      name: Faker.Pizza.company(),
      category_id: nil,
      material: Faker.Pizza.topping(),
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
      name: Faker.StarWars.character(),
      category_id: nil,
      material: Faker.StarWars.planet(),
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

    def painting_fixture(attrs \\ %{}) do
      {:ok, painting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_painting()

      painting
    end

    test "list_paintings/0 returns all paintings" do
      category = category_fixture()
      painting = painting_fixture(category_id: category.id)

      paintings_list = Admin.list_paintings()
      assert Enum.count(paintings_list) == 1

      db_painting = Enum.at(paintings_list, 0)
      assert db_painting.id == painting.id
      assert db_painting.category_id == category.id
    end

    test "list_paintings/1 returns only paintings associated with given category" do
      category = category_fixture()
      painting = painting_fixture(category_id: category.id)
      painting_fixture()

      assert Enum.count(Admin.list_paintings()) == 2

      fetched_paintings = Admin.list_paintings(category.id)
      assert Enum.count(fetched_paintings) == 1
      assert Enum.at(fetched_paintings, 0).id == painting.id
    end

    test "get_painting!/1 returns the painting with given id" do
      category = category_fixture()
      painting = painting_fixture(category_id: category.id)

      db_painting = Admin.get_painting!(painting.id)
      assert db_painting.id == painting.id
      assert db_painting.category_id == category.id
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

    @valid_attrs %{name: Faker.Pizza.style()}
    @update_attrs %{name: Faker.Pizza.pizza()}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_category()

      category
    end

    test "list_categories/0 returns all categories with preloaded paintings" do
      category = category_fixture()
      fetched_categories = Admin.list_categories()

      assert Enum.count(fetched_categories) === 1
      assert Enum.at(fetched_categories, 0).id === category.id
      refute is_nil(Enum.at(fetched_categories, 0).paintings)
    end

    test "fetch_categories_preview/1 returns all categories with `count` preloaded paintings" do
      (1..3)
      |> Enum.map(fn _i -> category_fixture() end)
      |> Enum.each(fn c ->
        (1..3) |> Enum.each(fn _i -> painting_fixture(category_id: c.id) end) end)

      categories = Admin.fetch_categories_preview(1)
      assert Enum.count(categories) === 3

      Enum.map(categories, fn c -> assert Enum.count(c.paintings) === 1 end)
    end

    test "get_category!/1 returns the category with given id and preloaded paintings" do
      category = category_fixture()
      fetched_category = Admin.get_category!(category.id)

      assert fetched_category.id === category.id
      refute is_nil(fetched_category.paintings)
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Admin.create_category(@valid_attrs)
      assert category.name == @valid_attrs.name
    end

    test "create_category/1 with existing name returns error changeset" do
      category = category_fixture()
      assert category.name == @valid_attrs.name

      assert {:error, %Ecto.Changeset{}} = Admin.create_category(@valid_attrs)
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Admin.update_category(category, @update_attrs)
      assert category.name == @update_attrs.name
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_category(category, @invalid_attrs)

      unchanged_category = Admin.get_category!(category.id)
      assert category.id == unchanged_category.id
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
