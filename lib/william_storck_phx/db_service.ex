defmodule WilliamStorckPhx.DBService do
  alias WilliamStorckPhx.{Painting, Repo, SlugGenerator}

  @base_url "https://s3.amazonaws.com/storck/paintings"

  def update_painting_source do
    Repo.all(Painting)
    |> Enum.map(fn painting -> create_painting_changeset(painting) end)
    |> Enum.map(fn changeset -> Repo.update!(changeset) end)
  end

  defp create_painting_changeset(painting) do
    source = painting.src
    |> String.split("storck")
    |> Enum.join("storck/paintings")

    Ecto.Changeset.change painting, src: source
  end

  def create_and_persist_painting(params, filename) do
    image_name = params["image_file"].filename
    with {:ok, src} <- set_source(image_name, filename),
      {:ok, [width, height]} <- get_file_dimensions(src),
      {:ok, size} <- set_painting_size(params["painting_height"], params["painting_width"]) do
        generate_payload(params, src, width, height, size)
        |> create_painting()
    end
  end

  defp create_painting(payload) do
    changeset = Painting.changeset(%Painting{}, payload)
    case Repo.insert(changeset) do
      {:ok, painting} ->
        SlugGenerator.create_and_persist_slug(painting)

        {:ok}
      {:error, _changeset} -> {:error, "Unable to create painting object"}
    end
  end

  defp generate_payload(params, src, width, height, size) do
    %{
      name: params["name"],
      material: params["material"],
      year:     params["year"],
      status:   params["status"],
      featured: false,
      src:      src,
      size:     size,
      height:   height,
      width:    width
    }
  end

  defp set_source(filename, image_name) when is_binary(filename) and is_binary(image_name) do
    {:ok, "#{@base_url}/#{filename}#{Path.extname(image_name)}"}
  end
  defp set_source(_, _), do: {:error, "Invalid filename"}

  defp get_file_dimensions(src), do: {:ok, Fastimage.size(src)}

  defp set_painting_size(height, width), do: {:ok, "#{height}\" x #{width}\""}
end
