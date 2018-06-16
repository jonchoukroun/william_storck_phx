defmodule WilliamStorckPhxWeb.SitemapController do
  use WilliamStorckPhxWeb, :controller
  alias WilliamStorckPhx.{Repo, Painting}

  def index(conn, _params) do
    render conn, "index.html", paintings: Repo.all(Painting)
  end
end
