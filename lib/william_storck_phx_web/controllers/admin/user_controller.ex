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
    with {:ok} <- validate_password(user_params["password"], user_params["password_confirm"]) do
      case Auth.create_user(user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: Routes.admin_user_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      {:error, message} ->
        render(conn, "new.html", changeset: Auth.change_user(%User{}), error_message: message)
    end
  end

  defp validate_password(password, confirm) when is_nil(password) or is_nil(confirm) do
    {:error, "Password cannot be blank."}
  end

  defp validate_password(password, password), do: {:ok}
  defp validate_password(_password, _confirm), do: {:error, "Passwords must match."}

  def edit(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    changeset = Auth.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    case Auth.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.admin_user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- validate_user(conn, id),
         true <- invalidate_superuser(user) do
      {:ok, _user} = Auth.delete_user(user)

      conn
      |> put_flash(:info, "User delete successfully.")
      |> redirect(to: Routes.admin_user_path(conn, :index))
    else
      _ ->
        conn
        |> redirect(to: Routes.admin_user_path(conn, :index))
    end
  end

  defp validate_user(conn, id) do
    user = Auth.get_user!(id)

    case user === Auth.get_user!(get_session(conn, :current_user_id)) do
      true -> {:error, :forbidden}
      false -> {:ok, user}
    end
  end

  defp invalidate_superuser(user), do: user.email !== "jonchoukroun@gmail.com"
end
