defmodule CourseBot.Repo.Migrations.CreateBots do
  use Ecto.Migration

  def change do
    create table(:bots) do
      add :name, :string
      add :description, :string

      timestamps()
    end

    create unique_index(:bots, [:name])
  end
end
