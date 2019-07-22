defmodule WilliamStorckPhxWeb.Admin.PortfolioController do
  use WilliamStorckPhxWeb, :controller

  alias WilliamStorckPhx.Admin

  def portfolio_1(conn, _params) do
    categories = Admin.list_categories(:random)
    render(conn, "portfolio_1.html", categories: categories)
  end
end
