defmodule WilliamStorckPhx.Painting do
  use Ecto.Schema
  import Ecto.Changeset


  schema "paintings" do
    field :slug
    field :featured, :boolean, default: false
    field :height, :integer
    field :material, :string
    field :name, :string
    field :size, :string
    field :src, :string
    field :status, :string
    field :price, :integer
    field :width, :integer
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(painting, attrs) do
    painting
    |> cast(attrs, [
      :slug, :name, :src, :material, :year, :size, :status, :price, :featured, :height, :width])
    |> validate_required([:name, :src, :material, :year, :size, :status, :featured, :height, :width])
  end
end
