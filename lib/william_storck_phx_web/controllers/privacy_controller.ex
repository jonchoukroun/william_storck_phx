defmodule WilliamStorckPhxWeb.PrivacyController do
  use WilliamStorckPhxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
