defmodule WilliamStorckPhx.Repo.Migrations.AddCategoryIdToPaintings do
  use Ecto.Migration

  def change do
    alter table(:paintings) do
      add :category_id, references(:categories)
    end
  end
end
