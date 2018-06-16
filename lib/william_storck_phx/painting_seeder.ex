defmodule WilliamStorckPhx.PaintingSeeder do
  alias WilliamStorckPhx.{Repo, Painting}

  @featured_names ["Along The Wye", "Magnolias", "Sea Wind"]
  @bucket_name "storck"

  def create_paintings_from_bucket() do
    get_bucket_contents()
    |> get_filenames()
    |> Enum.map(fn filename -> set_object_options(filename) end)
    |> Enum.map(fn opts -> struct(Painting, opts) end)
    |> Enum.map(fn struct -> Repo.insert(struct) end)
  end

  def get_bucket_contents() do
    ExAws.S3.list_objects(@bucket_name) |> ExAws.stream! |> Enum.to_list
  end

  def get_filenames(contents) do
    contents |> Enum.map(fn item -> item.key end)
  end

  def set_object_options(filename) do
    painting_elements = String.split(filename, "-")
    name = format_name(Enum.at(painting_elements, 0))
    opts = %{
      name: name,
      src: format_src(filename),
      material: format_material(Enum.at(painting_elements, 2)),
      year: format_year(Enum.at(painting_elements, 3)),
      size: format_size(Enum.at(painting_elements, 1)),
      status: get_status(Enum.at(painting_elements, -1)),
      featured: is_featured?(name)
    }

    insert_img_dimensions(opts)
  end

  def insert_img_dimensions(opts) do
    dimensions = Fastimage.size(opts.src)
    opts
    |> Map.put_new(:height, dimensions.height)
    |> Map.put_new(:width, dimensions.width)
  end

  def format_name(string) do
    format_string(String.split(string, "_"), nil)
  end

  def format_src(string) do
    ["https://s3.amazonaws.com", @bucket_name, string] |> Enum.join("/")
  end

  def format_material(string) do
    list = String.split(string, "_")
    insert_point = Enum.count(list) |> div(2)
    format_string(list, insert_point)
  end

  def format_year(string) do
    String.split(string, ".") |> List.first() |> String.to_integer()
  end

  def format_size(string) do
    string
    |> String.split("x")
    |> List.insert_at(1, "\" x ")
    |> List.insert_at(-1, "\"")
    |> Enum.join("")
  end

  def get_status(elements) do
    case String.starts_with?(elements, "sold") do
      true -> "sold"
      false -> "available"
    end
  end

  def is_featured?(name) when name in @featured_names, do: true

  def is_featured?(_name), do: false

  def format_string(list, insert_point) do
    list
    |> Enum.map(fn word -> String.capitalize(word) end)
    |> insert_on?(insert_point)
    |> Enum.join(" ")
  end

  def insert_on?(list, insert_point) when is_nil(insert_point), do: list

  def insert_on?(list, insert_point) when is_integer(insert_point) do
    List.insert_at(list, insert_point, "on")
  end

end
