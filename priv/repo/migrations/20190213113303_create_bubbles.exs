defmodule CourseBot.Repo.Migrations.CreateBubbles do
  use Ecto.Migration

  def change do
    create table(:bubbles) do
      add :name, :string
      add :convo, :string

      timestamps()
    end

    create unique_index(:bubbles, [:name])
  end
end
