defmodule WilliamStorckPhx.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias WilliamStorckPhx.Repo

  alias WilliamStorckPhx.Painting
  alias WilliamStorckPhx.Admin.Category


  @doc """
  Returns the list of paintings.

  ## Examples

      iex> list_paintings()
      [%Painting{}, ...]

  """
  def list_paintings do
    Painting |> preload([:category]) |> Repo.all
  end

  @doc """
  Returns the list of paintings filtered by category

  ## Examples

      iex> list_paintings(category_id)
      [%Painting{}, ...]

  """
  def list_paintings(category_id) do
    Painting
    |> preload([:category])
    |> where([p], p.category_id == ^category_id)
    |> Repo.all
  end

  @doc """
  Gets a single painting.

  Raises `Ecto.NoResultsError` if the Painting does not exist.

  ## Examples

      iex> get_painting!(123)
      %Painting{}

      iex> get_painting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_painting!(id), do: Painting |> preload([:category]) |> Repo.get!(id)

  @doc """
  Creates a painting.

  ## Examples

      iex> create_painting(%{field: value})
      {:ok, %Painting{}}

      iex> create_painting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_painting(attrs \\ %{}) do
    %Painting{}
    |> Painting.insert_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a painting.

  ## Examples

      iex> update_painting(painting, %{field: new_value})
      {:ok, %Painting{}}

      iex> update_painting(painting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_painting(%Painting{} = painting, attrs) do
    painting
    |> Painting.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Painting.

  ## Examples

      iex> delete_painting(painting)
      {:ok, %Painting{}}

      iex> delete_painting(painting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_painting(%Painting{} = painting) do
    Repo.delete(painting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking painting changes.

  ## Examples

      iex> change_painting(painting)
      %Ecto.Changeset{source: %Painting{}}

  """
  def change_painting(%Painting{} = painting) do
    Painting.update_changeset(painting, %{})
  end

  @doc """
  Returns the list of categories with preloaded paintings.

  Orders the paintings by random if argument is present.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

      iex> list_categories(:random)
      [%Category{}, ...]

  """
  def list_categories do
    Category |> preload([:paintings]) |> Repo.all()
  end

  def list_categories(:random) do
    paintings_query = Painting |> order_by(fragment("RANDOM()"))
    Category |> preload([paintings: ^paintings_query]) |> Repo.all()
  end

  @doc """
  Returns a randomized list of paintings for each category

  ## Examples

      iex > fetch_categories_preview(count = 3)
      [%Category{paintings: [%Painting{}, %Painting{}, %Painting{}], ...}, ...]
  """
  def fetch_categories_preview(count) do
    paintings = Painting |> order_by(fragment("RANDOM()"))
    Category
    |> preload([paintings: ^paintings])
    |> Repo.all()
    |> Enum.map(fn c -> Map.put(c, :paintings, Enum.slice(c.paintings, 0, count)) end)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """

  def get_category!(id), do: Category |> preload([:paintings]) |> Repo.get!(id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
