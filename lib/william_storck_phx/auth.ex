defmodule WilliamStorckPhx.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias WilliamStorckPhx.Repo

  alias WilliamStorckPhx.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Finds a user with query param.

  Returns nil if no user is found.

  Raises `Ecto.QueryError` if the query param is invalid.

  ## Examples

      iex> find_user(:email, "bob@aol.com")
      %User{}

      iex> find_user(:name, "ronald")
      %User{}

      iex> find_user(:waist_size, 32)
      ** (Ecto.QueryError)
  """
  @spec find_user(schema_field::atom(), Keyword.t())::EctoSchema.t() | nil
  def find_user(query, identifier) do
    from(u in User, where: field(u, ^query) == ^identifier)
    |> Repo.one()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Verifies a user based on their password.
  """
  def authenticate_user(email, password) when is_nil(email) or is_nil(password) do
    {:error, "Invalid attributes"}
  end

  def authenticate_user(email, password) do
    query = from(u in User, where: u.email == ^email)
    query |> Repo.one |> verify_password(password)
  end

  def signed_in?(conn), do: conn.assigns[:current_user]

  defp verify_password(nil, _), do: {:error, "Wrong email or password"}
  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Wrong email or password"}
    end
  end
end
