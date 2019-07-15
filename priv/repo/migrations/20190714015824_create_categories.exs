defmodule WilliamStorckPhx.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string

      timestamps()
    end

    create index(:categories, [:name])
  end
end
