defimpl Phoenix.Param, for: WilliamStorckPhx.Painting do
  def to_param(%{slug: slug}), do: "#{slug}"
end
