defmodule WilliamStorckPhxWeb.Plug.AuthenticateTest do
  use WilliamStorckPhxWeb.ConnCase

  import Plug.Test, only: [init_test_session: 2]

  alias WilliamStorckPhxWeb.Plugs.Authenticate

  describe "when user id in session" do
    setup [:create_user_session]

    test "populates conn assigns with user", %{conn: conn, user: user} do
      assert get_session(conn, :current_user_id)

      conn = conn |> Authenticate.call(%{})
      assert conn.assigns[:current_user].id === user.id
    end
  end

  describe "when no user id in session" do
    test "does nothing" do
      conn = build_conn(:get, "/")
      conn = get(conn, admin_landing_path(conn, :index))
      |> Authenticate.call(%{})

      refute get_session(conn, :current_user_id)
      refute conn.assigns[:current_user]
    end
  end

  defp create_user_session(_) do
    {:ok, user} = WilliamStorckPhx.Auth.create_user(%{
      name: "bob",
      email: "bob@aol.com",
      password: "xxxxxx"})

    conn = build_conn(:get, "/admin")
    |> init_test_session(current_user_id: user.id)

    {:ok, conn: conn, user: user}
  end
end
