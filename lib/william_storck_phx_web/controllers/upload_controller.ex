defmodule WilliamStorckPhxWeb.UploadController do
  use WilliamStorckPhxWeb, :controller

  alias WilliamStorckPhx.{Painting, DBService, UploadService}

  def new(conn, _params) do
    changeset = Painting.changeset(%Painting{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"painting" =>
  %{"name" => name,
    "material" => _material,
    "painting_height" => _painting_height,
    "painting_width" => _painting_width,
    "year" => _year,
    "status" => _status,
    "price" => _price,
    "image_file" => file} = params}) do
    with {:ok, source_url, dimensions} <- UploadService.upload_file(%{name: name, file: file}),
    {:ok} <- DBService.create_and_persist_painting(params, source_url, dimensions) do

      conn
      |> put_flash(:info, "#{name} uploaded successfully. You can upload another painting now.")
      |> redirect(to: Routes.upload_path(conn, :new))
    else
      {:error, message} ->
        changeset = Painting.changeset(%Painting{}, params)
        conn
        |> put_flash(:error, "Upload failed: #{message}")
        |> render("new.html", changeset: changeset)
    end
  end

  def create(conn, %{"painting" => invalid_params}) do
    changeset = Painting.changeset(%Painting{}, invalid_params)
    conn
    |> put_flash(:error, "Some fields are missing below.")
    |> render("new.html", changeset: changeset)
  end
end
