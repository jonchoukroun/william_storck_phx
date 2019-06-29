defmodule WilliamStorckPhxWeb.Plugs.Guest do
  import Plug.Conn
  import Phoenix.Controller

  alias WilliamStorckPhxWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if Plug.Conn.get_session(conn, :current_user_id) do
      conn
      |> put_flash(:info, "You're already logged in.")
      |> redirect(to: Routes.admin_landing_path(conn, :index))
      |> halt()
    end

    conn
  end
end
