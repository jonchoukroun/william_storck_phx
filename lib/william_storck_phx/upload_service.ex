defmodule WilliamStorckPhx.UploadService do
  alias ExAws.S3

  @bucket_name "storck/paintings"

  def upload_file(%{file: file}) when is_nil(file), do: {:error, "Not a valid image file"}

  def upload_file(%{name: name, file: file}) do
    uid = Ecto.UUID.generate()
    filename = "#{uid}-#{format(name)}"

    with {:ok, image_binary} <- File.read(file.path) do
      full_filename = "#{filename}#{Path.extname(file.filename)}"
      opts = %{content_type: file.content_type, acl: :public_read}

      S3.put_object(@bucket_name, full_filename, image_binary, opts)
      |> ExAws.request!

      {:ok, filename}
    else
      {:error, _reason} -> {:error, "Cannot read file"}
    end
  end

  def upload_file(_params), do: {:error, :invalid_upload_params}

  defp format(string) do
    String.downcase(string) |> String.split() |> Enum.join("-")
  end
end
