defmodule WilliamStorckPhxWeb.SitemapController do
  use WilliamStorckPhxWeb, :controller

  def index(conn, _params) do
    paintings = Repo.all(Painting)
    |> Enum.map(:name)
    render conn, "index.html", paintings: paintings
  end
end
