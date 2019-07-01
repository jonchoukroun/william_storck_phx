defmodule WilliamStorckPhxWeb.Plugs.Authenticate do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn
      id ->
        user = WilliamStorckPhx.Auth.get_user!(id)
        assign(conn, :current_user, user)
    end
  end
end
