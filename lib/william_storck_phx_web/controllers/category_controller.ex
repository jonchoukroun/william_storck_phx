defmodule WilliamStorckPhxWeb.CategoryController do
  use WilliamStorckPhxWeb, :controller

  alias WilliamStorckPhx.Admin

  def show(conn, %{"id" => id}) do
    category = Admin.get_category!(id)
    render(conn, "show.html", category: category)
  end
end
