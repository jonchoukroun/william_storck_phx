defmodule WilliamStorckPhx.Repo.Migrations.AddPriceToPaintings do
  use Ecto.Migration

  def change do
    alter table("paintings") do
      add :price, :integer
    end
  end
end
