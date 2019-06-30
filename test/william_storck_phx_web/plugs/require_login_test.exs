defmodule WilliamStorckPhxWeb.Plug.RequireLoginTest do
  use WilliamStorckPhxWeb.ConnCase

  alias WilliamStorckPhxWeb.Plugs.RequireLogin

  test "user is redirect to login if not signed in" do
    conn = build_conn(:get, "/admin")
    |> call_plug()

    assert redirected_to(conn) === "/admin/login"
  end

  test "user passes through when logged in" do
    conn = build_conn(:get, "/admin")
    |> assign(:current_user, create_user())
    |> call_plug()

    assert conn.status !== 302
  end

  defp create_user do
    {:ok, user} = WilliamStorckPhx.Auth.create_user(%{
      name: "bob",
      email: "bob@aol.com",
      password: "xxxxxx"})

      user
  end

  defp call_plug(conn), do: RequireLogin.call(conn, %{})
end
