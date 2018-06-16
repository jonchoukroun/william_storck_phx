defmodule WilliamStorckPhxWeb.PaintingsView do
  use WilliamStorckPhxWeb, :view

  def compute_style(painting) do
    width = compute_aspect_ratio(painting)
            |> estimate_width
    width_style = "width: #{width}px;"
    flex_style  = "flex-grow: #{width};"
    width_style <> flex_style
  end

  def compute_spacer_padding(painting) do
    compute_aspect_ratio(painting)
    |> :math.pow(-1)
    |> Kernel.*(100)
    |> round()
  end

  def compute_aspect_ratio(painting) do
    painting.width / painting.height
  end

  def estimate_width(aspect_ratio) do
    round(aspect_ratio * 235)    # starting height
  end
end
