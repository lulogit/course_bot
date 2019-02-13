defmodule CourseBot.BubblesTest do
  use CourseBot.DataCase

  alias CourseBot.Bubbles

  describe "bubbles" do
    alias CourseBot.Bubbles.Bubble

    @valid_attrs %{convo: "some convo", name: "some name"}
    @update_attrs %{convo: "some updated convo", name: "some updated name"}
    @invalid_attrs %{convo: nil, name: nil}

    def bubble_fixture(attrs \\ %{}) do
      {:ok, bubble} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bubbles.create_bubble()

      bubble
    end

    test "list_bubbles/0 returns all bubbles" do
      bubble = bubble_fixture()
      assert Bubbles.list_bubbles() == [bubble]
    end

    test "get_bubble!/1 returns the bubble with given id" do
      bubble = bubble_fixture()
      assert Bubbles.get_bubble!(bubble.id) == bubble
    end

    test "create_bubble/1 with valid data creates a bubble" do
      assert {:ok, %Bubble{} = bubble} = Bubbles.create_bubble(@valid_attrs)
      assert bubble.convo == "some convo"
      assert bubble.name == "some name"
    end

    test "create_bubble/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bubbles.create_bubble(@invalid_attrs)
    end

    test "update_bubble/2 with valid data updates the bubble" do
      bubble = bubble_fixture()
      assert {:ok, bubble} = Bubbles.update_bubble(bubble, @update_attrs)
      assert %Bubble{} = bubble
      assert bubble.convo == "some updated convo"
      assert bubble.name == "some updated name"
    end

    test "update_bubble/2 with invalid data returns error changeset" do
      bubble = bubble_fixture()
      assert {:error, %Ecto.Changeset{}} = Bubbles.update_bubble(bubble, @invalid_attrs)
      assert bubble == Bubbles.get_bubble!(bubble.id)
    end

    test "delete_bubble/1 deletes the bubble" do
      bubble = bubble_fixture()
      assert {:ok, %Bubble{}} = Bubbles.delete_bubble(bubble)
      assert_raise Ecto.NoResultsError, fn -> Bubbles.get_bubble!(bubble.id) end
    end

    test "change_bubble/1 returns a bubble changeset" do
      bubble = bubble_fixture()
      assert %Ecto.Changeset{} = Bubbles.change_bubble(bubble)
    end
  end
end
