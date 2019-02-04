defmodule WilliamStorckPhx.UploadService do
  alias ExAws.S3

  @bucket_name "storck/paintings"

  def upload_file(%{file: file}) when is_nil(file), do: {:error, "Not a valid image file"}

  def upload_file(%{name: name, file: file}) do
    uid = Ecto.UUID.generate()
    image_source = "#{uid}-#{format(name)}"
    full_source = "#{image_source}#{Path.extname(file.filename)}"

    with {:ok, image_binary} <- File.read(file.path),
    %{width: _width, height: _height} = dimensions <- Fastimage.size(file.path) do
      if Mix.env() !== :test do
        opts = %{content_type: file.content_type, acl: :public_read}
        S3.put_object(@bucket_name, full_source, image_binary, opts)
        |> ExAws.request!
      end

      {:ok, full_source, dimensions}
    else
      {:error, _reason} -> {:error, "Cannot read file"}
    end
  end

  def upload_file(_params), do: {:error, :invalid_upload_params}

  defp format(string), do: String.downcase(string) |> String.split() |> Enum.join("-")
end
