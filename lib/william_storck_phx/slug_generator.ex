defmodule WilliamStorckPhx.SlugGenerator do
  alias WilliamStorckPhx.{Repo, Painting}

  @salt "YBPKJijFI5Q755FWDeWQDLZKOqYFOY06UQgI1t8/wbVNLGCMy3blewYGS+wvAFWn"

  def update_with_slugs do
    Repo.all(Painting)
    |> Enum.map(fn(p) -> create_and_persist_slug(p) end)
  end

  def create_and_persist_slug(painting) do
    changeset = Ecto.Changeset.change painting, slug: generate_slug(painting)
    Repo.update! changeset
  end

  defp generate_slug(painting) do
    [
      format_name(Map.get(painting, :name)),
      hash_id(Map.get(painting, :id))
    ] |> Enum.join("-")
  end

  defp format_name(name) do
    String.downcase(name) |> String.split() |> Enum.join("-")
  end

  defp hash_id(id) do
    Hashids.new(salt: @salt)
    |> Hashids.encode(id)
  end
end
