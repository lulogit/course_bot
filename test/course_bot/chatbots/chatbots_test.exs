defmodule CourseBot.ChatbotsTest do
  use CourseBot.DataCase

  alias CourseBot.Chatbots

  describe "bots" do
    alias CourseBot.Chatbots.Bot

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def bot_fixture(attrs \\ %{}) do
      {:ok, bot} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chatbots.create_bot()

      bot
    end

    test "list_bots/0 returns all bots" do
      bot = bot_fixture()
      assert Chatbots.list_bots() == [bot]
    end

    test "get_bot!/1 returns the bot with given id" do
      bot = bot_fixture()
      assert Chatbots.get_bot!(bot.id) == bot
    end

    test "create_bot/1 with valid data creates a bot" do
      assert {:ok, %Bot{} = bot} = Chatbots.create_bot(@valid_attrs)
      assert bot.description == "some description"
      assert bot.name == "some name"
    end

    test "create_bot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chatbots.create_bot(@invalid_attrs)
    end

    test "update_bot/2 with valid data updates the bot" do
      bot = bot_fixture()
      assert {:ok, bot} = Chatbots.update_bot(bot, @update_attrs)
      assert %Bot{} = bot
      assert bot.description == "some updated description"
      assert bot.name == "some updated name"
    end

    test "update_bot/2 with invalid data returns error changeset" do
      bot = bot_fixture()
      assert {:error, %Ecto.Changeset{}} = Chatbots.update_bot(bot, @invalid_attrs)
      assert bot == Chatbots.get_bot!(bot.id)
    end

    test "delete_bot/1 deletes the bot" do
      bot = bot_fixture()
      assert {:ok, %Bot{}} = Chatbots.delete_bot(bot)
      assert_raise Ecto.NoResultsError, fn -> Chatbots.get_bot!(bot.id) end
    end

    test "change_bot/1 returns a bot changeset" do
      bot = bot_fixture()
      assert %Ecto.Changeset{} = Chatbots.change_bot(bot)
    end
  end
end
