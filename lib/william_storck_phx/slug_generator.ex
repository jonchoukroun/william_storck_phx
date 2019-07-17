defmodule WilliamStorckPhx.SlugGenerator do

  @salt "YBPKJijFI5Q755FWDeWQDLZKOqYFOY06UQgI1t8/wbVNLGCMy3blewYGS+wvAFWn"

  def generate_slug(name) when is_nil(name) or not is_binary(name), do: {:error, :invalid_name}

  def generate_slug(name) do
    [format_name(name), generate_hash()]
    |> Enum.join("-")
  end

  defp format_name(name) do
    String.downcase(name) |> String.split() |> Enum.join("-")
  end

  defp generate_hash do
    Hashids.new(salt: @salt)
    |> Hashids.encode(:rand.uniform(4294967296))
  end
end
