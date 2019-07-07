defmodule WilliamStorckPhx.UploadService do
  alias ExAws.S3

  @bucket_name "storck/paintings"
  @base_url "https://s3.amazonaws.com/#{@bucket_name}"

  def upload_file(%{name: name, file: file}) do
    with {:ok, source} <- build_filename(name, file),
    {:ok, image_binary} <- File.read(file.path),
    {:ok, dimensions} <- Fastimage.size(file.path) do
      if Application.get_all_env(:ex_aws) |> Enum.count() > 0 do
        upload_to_s3(file, image_binary, source, dimensions)
      else
        %{src: build_source_url(source), height: dimensions.height, width: dimensions.width}
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
      {:ok, _} ->
        %{src: build_source_url(source), height: dimensions.height, width: dimensions.width}
      {:error, msg} ->
        {:error, msg}
    end
  end

  defp build_filename(name, file) do
    uid = Ecto.UUID.generate()
    image_source = "#{uid}-#{format(name)}"
    full_source = "#{image_source}#{Path.extname(file.filename)}"
    {:ok, full_source}
  end

  defp format(string), do: String.downcase(string) |> String.split() |> Enum.join("-")

  defp build_source_url(source_url) when is_binary(source_url), do: "#{@base_url}/#{source_url}"
end
