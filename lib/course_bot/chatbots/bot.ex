defmodule CourseBot.Chatbots.Bot do
  use Ecto.Schema
  import Ecto.Changeset


  schema "bots" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(bot, attrs) do
    bot
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end
end
