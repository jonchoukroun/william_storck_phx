defmodule WilliamStorckPhxWeb.Admin.SessionController do
  use WilliamStorckPhxWeb, :controller

  def new(conn, _params) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: Routes.admin_landing_path(conn, :index))
      |> halt()
    end

    render(conn, "new.html")
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case WilliamStorckPhx.Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Welcome, #{user.name}!")
        |> redirect(to: Routes.admin_landing_path(conn, :index))

      {:error, message} ->
        conn
        |> delete_session(:current_user_id)
        |> render("new.html", error_message: message)
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "You are logged out.")
    |> redirect(to: Routes.admin_session_path(conn, :new))
  end
end
