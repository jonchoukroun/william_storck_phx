defmodule WilliamStorckPhxWeb.Admin.UserController do
  use WilliamStorckPhxWeb, :controller

  alias WilliamStorckPhx.Auth
  alias WilliamStorckPhx.Auth.User

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Auth.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok} <- validate_password(user_params) do
      case Auth.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: Routes.admin_user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      {:error, message} ->
        render(conn, "new.html", changeset: Auth.change_user(%User{}), error_message: message)
    end
  end

  defp validate_password(%{"password" => password, "password_confirm" => confirm}) do
    if password == confirm do
      {:ok}
    else
      {:error, "Passwords must match."}
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    changeset = Auth.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    case Auth.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.admin_user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    {:ok, _user} = Auth.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.admin_user_path(conn, :index))
  end
end
