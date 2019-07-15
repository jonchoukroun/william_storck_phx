defmodule WilliamStorckPhx.Painting do
  use Ecto.Schema

  import Ecto.Changeset

  alias WilliamStorckPhx.{UploadService, SlugGenerator}

  @derive {Phoenix.Param, [:id, :slug]}

  schema "paintings" do
    field :name, :string
    field :material, :string

    field :painting_height, :integer, virtual: true
    field :painting_width, :integer, virtual: true
    field :height, :integer
    field :width, :integer

    field :price, :integer
    field :status, :string

    field :image_file, :any, virtual: true
    field :src, :string

    field :size, :string
    field :slug

    belongs_to :category, WilliamStorckPhx.Admin.Category

    field :featured, :boolean, default: false

    timestamps()
  end

  @doc false
  def insert_changeset(painting, attrs) do
    painting
    |> cast(attrs, [
      :name, :material, :painting_height, :painting_width, :price, :status, :image_file])
    |> validate_required([
      :name, :material, :painting_height, :painting_width, :status, :image_file])
    |> upload_painting()
    |> cast(attrs, [:src, :height, :width])
    |> validate_required([:src, :height, :width])
    |> change(image_file: nil)
    |> format_size()
    |> cast(attrs, [:size])
    |> validate_required([:size])
    |> change(%{painting_height: nil, painting_width: nil})
    |> generate_slug()
    |> cast(attrs, [:slug])
    |> validate_required([:slug])
  end

  def update_changeset(painting, attrs) do
    painting
    |> cast(attrs, [
      :name, :material, :painting_height, :painting_width, :price, :status])
    |> format_size()
    |> generate_slug()
    |> cast(attrs, [:slug])
  end

  defp upload_painting(%Ecto.Changeset{valid?: true,
  changes: %{name: name, image_file: image_file}} = changeset) do
    with %{src: _src, height: _height, width: _width} = changes <- UploadService.upload_file(
    %{name: name, file: image_file}) do
      change(changeset, changes)
    else
      {:error, msg} ->
        add_error(changeset, :src, "Upload failed: #{msg}")
    end
  end

  defp upload_painting(changeset), do: changeset

  defp format_size(%Ecto.Changeset{valid?: true,
  changes: %{painting_height: height, painting_width: width}} = changeset) do
    change(changeset, size: "#{height}\" x #{width}\"")
  end

  defp format_size(%Ecto.Changeset{valid?: true, changes: %{painting_height: _}} = changeset) do
    add_error(changeset, :painting_width, "Cannot be blank")
  end

  defp format_size(%Ecto.Changeset{valid?: true, changes: %{painting_width: _}} = changeset) do
    add_error(changeset, :painting_height, "Cannot be blank")
  end

  defp format_size(changeset), do: changeset

  defp generate_slug(%Ecto.Changeset{valid?: true,
  changes: %{name: name}} = changeset) when not is_nil(name) do
    change(changeset, slug: SlugGenerator.generate_slug(name))
  end

  defp generate_slug(changeset), do: changeset
end
