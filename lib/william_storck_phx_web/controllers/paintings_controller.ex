defmodule WilliamStorckPhxWeb.PaintingsController do
  use WilliamStorckPhxWeb, :controller
  alias WilliamStorckPhx.{Repo, Painting}

  def index(conn, _params) do
    render conn, "index.html", paintings: Repo.all(Painting)
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", painting: Repo.get(Painting, id)
  end
end
