defmodule WilliamStorckPhx.Repo.Migrations.RemoveActiveFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :is_active
    end
  end
end
