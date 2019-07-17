defmodule WilliamStorckPhx.Repo.Migrations.AddUniqueIndexOnCategoryName do
  use Ecto.Migration

  def change do
    drop index("categories", [:name])
    create unique_index("categories", [:name])
  end
end
