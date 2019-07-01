defmodule WilliamStorckPhxWeb.Admin.UserView do
  use WilliamStorckPhxWeb, :view

  def is_logged_in?(conn, user) do
    conn.assigns[:current_user] === user
  end
end
