defmodule WilliamStorckPhx.Repo.Migrations.CreatePaintings do
  use Ecto.Migration

  def change do
    create table(:paintings) do
      add :name, :string
      add :src, :string
      add :material, :string
      add :year, :integer
      add :size, :string
      add :status, :string
      add :featured, :boolean, default: false, null: false
      add :height, :integer
      add :width, :integer

      timestamps()
    end

  end
end
