defmodule WilliamStorckPhxWeb.ContactController do
  use WilliamStorckPhxWeb, :controller
  alias SendGrid.Email

  def index(conn, _params) do
    render conn, "index.html"
  end

  def capture_email(conn, params) do
    contact = params["contact"]
    case build_and_send_email(contact["email"], contact["name"], contact["message"]) do
      :ok ->
        render conn, "index.html", success: true

      {:error, reason} ->
        render conn, "index.html", error_message: parse_error(reason)

      :error ->
        render conn, "index.html",
          error_message: "Sorry, something went wrong. Please try again later."
    end
  end

  defp build_and_send_email(email, _name, _message) when is_nil(email), do: :error

  defp build_and_send_email(email, name, message) do
    Email.build()
    |> Email.add_to("swancovestudio@gmail.com")
    |> Email.put_from(email)
    |> Email.put_subject("New message from #{name}")
    |> Email.put_text(message)
    |> SendGrid.Mailer.send()
  end

  defp parse_error(_reason) do
    "Sorry, something went wrong. Please try again later."
  end
end
