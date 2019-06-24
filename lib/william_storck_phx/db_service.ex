defmodule WilliamStorckPhx.DBService do
  alias WilliamStorckPhx.{Painting, Repo, SlugGenerator}

  @base_url "https://s3.amazonaws.com/storck/paintings"

  def create_and_persist_painting(params, source_url, dimensions) do
    with {:ok, src} <- set_source(source_url),
    {:ok, size} <- set_painting_size(params["painting_height"], params["painting_width"]) do
        generate_payload(params, src, dimensions.width, dimensions.height, size)
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
      status:   params["status"],
      price:    params["price"],
      featured: false,
      src:      src,
      size:     size,
      height:   height,
      width:    width
    }
  end

  defp set_source(source_url) when is_binary(source_url), do: {:ok, "#{@base_url}/#{source_url}"}
  defp set_source(_), do: {:error, "Invalid filename"}

  defp set_painting_size(height, width), do: {:ok, "#{height}\" x #{width}\""}
end
