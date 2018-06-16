defmodule WilliamStorckPhxWeb.ContactController do
  use WilliamStorckPhxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def capture_email(conn, params) do
    url = "https://formspree.io/swancovestudio@gmail.com"
    headers = [{"Accept", "application/json"}, {"Content-Type", "application/json"}]

    {:ok, body} = Poison.encode %{
      name: params["contact"]["name"],
      email: params["contact"]["email"],
      message: params["contact"]["message"]
    }

    response = HTTPotion.post(url, [body: body, headers: headers])
    IO.inspect(response)

    case response.status_code do
      400 ->
        render conn, "index.html",
          error_message: "Sorry, something went wrong. Please try again later."
      _ ->
        render conn, "index.html", success: true
    end
  end
end
