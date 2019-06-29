defmodule WilliamStorckPhxWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  
  alias WilliamStorckPhxWeb.Router.Helpers, as: Routes
  
  def init(opts), do: opts

  def call(conn, _opts) do
    if current_user_id = Plug.Conn.get_session(conn, :current_user_id) do
      conn
      |> assign(:current_user, WilliamStorckPhx.Auth.get_user!(current_user_id))
    else
      conn
      |> redirect(to: Routes.admin_session_path(conn, :new))
      |> halt()
    end
  end
end
