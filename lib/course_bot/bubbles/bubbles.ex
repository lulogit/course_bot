defmodule CourseBot.Bubbles do
  @moduledoc """
  The Bubbles context.
  """

  import Ecto.Query, warn: false
  alias CourseBot.Repo

  alias CourseBot.Bubbles.Bubble

  @doc """
  Returns the list of bubbles.

  ## Examples

      iex> list_bubbles()
      [%Bubble{}, ...]

  """
  def list_bubbles do
    Repo.all(Bubble)
  end

  @doc """
  Gets a single bubble.

  Raises `Ecto.NoResultsError` if the Bubble does not exist.

  ## Examples

      iex> get_bubble!(123)
      %Bubble{}

      iex> get_bubble!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bubble!(id), do: Repo.get!(Bubble, id)

  @doc """
  Creates a bubble.

  ## Examples

      iex> create_bubble(%{field: value})
      {:ok, %Bubble{}}

      iex> create_bubble(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bubble(attrs \\ %{}) do
    %Bubble{}
    |> Bubble.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bubble.

  ## Examples

      iex> update_bubble(bubble, %{field: new_value})
      {:ok, %Bubble{}}

      iex> update_bubble(bubble, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bubble(%Bubble{} = bubble, attrs) do
    bubble
    |> Bubble.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Bubble.

  ## Examples

      iex> delete_bubble(bubble)
      {:ok, %Bubble{}}

      iex> delete_bubble(bubble)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bubble(%Bubble{} = bubble) do
    Repo.delete(bubble)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bubble changes.

  ## Examples

      iex> change_bubble(bubble)
      %Ecto.Changeset{source: %Bubble{}}

  """
  def change_bubble(%Bubble{} = bubble) do
    Bubble.changeset(bubble, %{})
  end
end
