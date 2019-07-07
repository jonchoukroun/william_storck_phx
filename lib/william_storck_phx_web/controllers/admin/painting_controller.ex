defmodule WilliamStorckPhxWeb.Admin.PaintingController do
  use WilliamStorckPhxWeb, :controller

  alias WilliamStorckPhx.Admin
  alias WilliamStorckPhx.Painting

  def index(conn, _params) do
    paintings = Admin.list_paintings()
    render(conn, "index.html", paintings: paintings)
  end

  def new(conn, _params) do
    changeset = Admin.change_painting(%Painting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"painting" => painting_params}) do
    case Admin.create_painting(painting_params) do
      {:ok, painting} ->
        conn
        |> put_flash(:info, "Painting created successfully.")
        |> redirect(to: Routes.admin_painting_path(conn, :show, painting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    painting = Admin.get_painting!(id)
    render(conn, "show.html", painting: painting)
  end

  def edit(conn, %{"id" => id}) do
    painting = Admin.get_painting!(id)
    changeset = Admin.change_painting(painting)
    render(conn, "edit.html", painting: painting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "painting" => painting_params}) do
    painting = Admin.get_painting!(id)

    case Admin.update_painting(painting, painting_params) do
      {:ok, painting} ->
        conn
        |> put_flash(:info, "Painting updated successfully.")
        |> redirect(to: Routes.admin_painting_path(conn, :show, painting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", painting: painting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    painting = Admin.get_painting!(id)
    {:ok, _painting} = Admin.delete_painting(painting)

    conn
    |> put_flash(:info, "Painting deleted successfully.")
    |> redirect(to: Routes.admin_painting_path(conn, :index))
  end
end
