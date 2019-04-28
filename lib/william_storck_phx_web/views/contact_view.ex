defmodule WilliamStorckPhxWeb.ContactView do
  use WilliamStorckPhxWeb, :view

  def text_area_placeholder(painting) when is_nil(painting), do: "Tell us what you think..."

  def text_area_placeholder(painting), do: "I really like the piece \"#{painting}\"..."
end
