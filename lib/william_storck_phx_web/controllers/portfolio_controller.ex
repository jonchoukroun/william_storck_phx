defmodule WilliamStorckPhxWeb.PortfolioController do
  use WilliamStorckPhxWeb, :controller

  alias WilliamStorckPhx.Admin

  def index(conn, _params) do
    categories = Admin.fetch_categories_preview(3)
    render(conn, "index.html", categories: categories)
  end
end
