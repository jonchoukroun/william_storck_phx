defmodule WilliamStorckPhx.Repo.Migrations.AddSlugToPaintings do
  use Ecto.Migration

  def change do
    alter table(:paintings) do
      add :slug, :string
    end

    create index(:paintings, [:slug], unique: true)
  end
end
