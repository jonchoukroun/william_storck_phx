defmodule WilliamStorckPhxWeb.Admin.PaintingView do
  use WilliamStorckPhxWeb, :view

  alias WilliamStorckPhx.Painting

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

  def category_options(categories) when is_nil(categories), do: ["Create a category first"]
  def category_options(categories) do
    Enum.map(categories, fn c -> {c.name, c.id} end)
  end
end
