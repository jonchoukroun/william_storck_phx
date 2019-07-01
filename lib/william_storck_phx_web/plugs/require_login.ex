defmodule WilliamStorckPhxWeb.Plugs.RequireLogin do
  import Plug.Conn

  alias WilliamStorckPhxWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: Routes.admin_session_path(conn, :new))
      |> halt()
    end
  end
end
