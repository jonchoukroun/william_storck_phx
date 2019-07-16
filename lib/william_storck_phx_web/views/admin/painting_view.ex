defmodule WilliamStorckPhxWeb.Admin.PaintingView do
  use WilliamStorckPhxWeb, :view

  alias WilliamStorckPhx.Painting

  def painting_attrs do
    screened_attrs = [:id, :inserted_at, :updated_at, :src, :slug, :featured, :height, :width]
    Painting.__schema__(:fields)
    |> Enum.reject(fn(key) -> Enum.member?(screened_attrs, key) end)
  end

  def current_height(size) do
    size
    |> String.split()
    |> Enum.at(0)
  end

  def current_width(size) do
    size
    |> String.split()
    |> Enum.reverse()
    |> Enum.at(0)
  end

  def category_options(categories) when is_nil(categories), do: []
  def category_options(categories) do
    Enum.map(categories, fn c -> {c.name, c.id} end)
  end
end
