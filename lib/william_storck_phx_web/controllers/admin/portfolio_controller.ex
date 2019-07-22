defmodule WilliamStorckPhxWeb.Admin.PortfolioController do
  use WilliamStorckPhxWeb, :controller

  alias WilliamStorckPhx.Admin

  def portfolio_1(conn, _params) do
    categories = Admin.fetch_categories_preview(1)
    render(conn, "portfolio_1.html", categories: categories)
  end

  def portfolio_2(conn, _params) do
    categories = Admin.fetch_categories_preview(3)
    render(conn, "portfolio_2.html", categories: categories)
  end
end
