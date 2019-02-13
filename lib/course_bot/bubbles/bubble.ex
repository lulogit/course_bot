defmodule CourseBot.Bubbles.Bubble do
  use Ecto.Schema
  import Ecto.Changeset


  schema "bubbles" do
    field :convo, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(bubble, attrs) do
    bubble
    |> cast(attrs, [:name, :convo])
    |> validate_required([:name, :convo])
    |> unique_constraint(:name)
  end
end
