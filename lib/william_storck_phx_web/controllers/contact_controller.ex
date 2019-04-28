defmodule WilliamStorckPhxWeb.ContactController do
  use WilliamStorckPhxWeb, :controller
  alias SendGrid.Email

  def index(conn, %{"painting" => painting}), do: render conn, "index.html", painting: painting
  def index(conn, params), do: render conn, "index.html"

  def capture_email(conn, params) do
    contact = params["contact"]
    case send_email(contact["email"], contact["name"], contact["message"], contact["painting"]) do
      :ok ->
        render conn, "index.html", success: true

      {:error, reason} ->
        render conn, "index.html", error_message: parse_error(reason)

      :error ->
        render conn, "index.html",
          error_message: "Sorry, something went wrong. Please try again later."
    end
  end

  defp send_email(email, _name, _message, _painting) when is_nil(email), do: :error

  defp send_email(email, name, message, painting) do
    Email.build()
    |> Email.add_to("swancovestudio@gmail.com")
    |> Email.put_from(email)
    |> Email.put_subject(write_subject(name, painting))
    |> Email.put_text(message)
    |> SendGrid.Mailer.send()
  end

  defp write_subject(name, painting) when is_nil(painting), do: "New message from #{name}"
  defp write_subject(name, painting), do: "#{name} is interested in #{painting}"

  defp parse_error(_reason) do
    "Sorry, something went wrong. Please try again later."
  end
end
