defmodule CourseBot.Repo.Migrations.CreateBubbles do
  use Ecto.Migration

  def change do

    alter table(:bubbles) do
      modify :convo, :text
    end

  end
end
