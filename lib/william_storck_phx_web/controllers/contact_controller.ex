defmodule WilliamStorckPhxWeb.ContactController do
  use WilliamStorckPhxWeb, :controller
  alias WilliamStorckPhx.Mailer
  import Bamboo.Email

  def index(conn, _params) do
    render conn, "index.html"
  end

  def capture_email(conn, params) do
    email = new_email()
    |> to("swancovestudio@gmail.com")
    |> from(params["contact"]["email"])
    |> subject("New message from #{params["contact"]["name"]}")
    |> text_body(params["contact"]["message"])

    Mailer.deliver_now email

    render conn, "index.html", success: true
  end
end
