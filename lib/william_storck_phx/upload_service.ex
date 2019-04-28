defmodule WilliamStorckPhx.UploadService do
  alias ExAws.S3

  @bucket_name "storck/paintings"

  def upload_file(%{file: file}) when is_nil(file), do: {:error, :invalid_image_file}

  def upload_file(%{name: name, file: file}) do
    with {:ok, source} <- build_filename(name, file),
    {:ok, image_binary} <- File.read(file.path),
    {:ok, dimensions} <- Fastimage.size(file.path) do
      if Application.get_all_env(:ex_aws) |> Enum.count() > 0 do
        upload_to_s3(file, image_binary, source, dimensions)
      else
        {:ok, source, dimensions}
      end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def upload_file(_params), do: {:error, :invalid_upload_params}

  defp upload_to_s3(file, image_binary, source, dimensions) do
    opts = %{content_type: file.content_type, acl: :public_read}
    payload = S3.put_object(@bucket_name, source, image_binary, opts)

    case ExAws.request(payload) do
      {:ok, _} -> {:ok, source, dimensions}
      {:error, msg} -> {:error, msg}
    end
  end

  defp build_filename(name, file) do
    uid = Ecto.UUID.generate()
    image_source = "#{uid}-#{format(name)}"
    full_source = "#{image_source}#{Path.extname(file.filename)}"
    {:ok, full_source}
  end

  defp format(string), do: String.downcase(string) |> String.split() |> Enum.join("-")
end
