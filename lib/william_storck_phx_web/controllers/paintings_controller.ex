defmodule WilliamStorckPhxWeb.PaintingsController do
  use WilliamStorckPhxWeb, :controller
  alias WilliamStorckPhx.{Repo, Painting}
  import Ecto.Query

  def index(conn, _params) do
    query = from p in Painting, order_by: fragment("RANDOM()")
    render conn, "index.html", paintings: Repo.all(query)
  end

  def show(conn, %{"id" => slug}) do
    case Repo.get_by(Painting, slug: slug) do
      nil ->
        index(conn, %{})
      painting ->
        render conn, "show.html", painting: Repo.get_by!(Painting, slug: slug)
    end
  end
end
