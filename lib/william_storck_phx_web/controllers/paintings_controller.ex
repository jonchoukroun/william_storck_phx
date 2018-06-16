defmodule WilliamStorckPhxWeb.PaintingsController do
  use WilliamStorckPhxWeb, :controller
  alias WilliamStorckPhx.{Repo, Painting}

  def index(conn, _params) do
    render conn, "index.html", paintings: Repo.all(Painting)
  end

  def show(conn, %{"id" => slug}) do
    render conn, "show.html", painting: Repo.get_by!(Painting, slug: slug)
  end
end
