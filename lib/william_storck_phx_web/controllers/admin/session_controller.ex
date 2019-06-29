defmodule WilliamStorckPhxWeb.Admin.SessionController do
  use WilliamStorckPhxWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"email" => email, "password" => password}) do
    case WilliamStorckPhxWeb.Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Welcome, #{user.name}!")
        |> redirect(to: Routes.admin_user_path(conn, :show, user))

      {:error, message} ->
        conn
        |> delete_session(:current_user_id)
        |> put_flash(:error, message)
        |> render(conn, "new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "You are logged out.")
    |> redirect(to: Routes.admin_user_path(conn, :index))
  end
end
