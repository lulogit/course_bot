defmodule CourseBotWeb.BotControllerTest do
  use CourseBotWeb.ConnCase

  alias CourseBot.Chatbots

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:bot) do
    {:ok, bot} = Chatbots.create_bot(@create_attrs)
    bot
  end

  describe "index" do
    test "lists all bots", %{conn: conn} do
      conn = get conn, bot_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Bots"
    end
  end

  describe "new bot" do
    test "renders form", %{conn: conn} do
      conn = get conn, bot_path(conn, :new)
      assert html_response(conn, 200) =~ "New Bot"
    end
  end

  describe "create bot" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, bot_path(conn, :create), bot: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == bot_path(conn, :show, id)

      conn = get conn, bot_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Bot"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, bot_path(conn, :create), bot: @invalid_attrs
      assert html_response(conn, 200) =~ "New Bot"
    end
  end

  describe "edit bot" do
    setup [:create_bot]

    test "renders form for editing chosen bot", %{conn: conn, bot: bot} do
      conn = get conn, bot_path(conn, :edit, bot)
      assert html_response(conn, 200) =~ "Edit Bot"
    end
  end

  describe "update bot" do
    setup [:create_bot]

    test "redirects when data is valid", %{conn: conn, bot: bot} do
      conn = put conn, bot_path(conn, :update, bot), bot: @update_attrs
      assert redirected_to(conn) == bot_path(conn, :show, bot)

      conn = get conn, bot_path(conn, :show, bot)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, bot: bot} do
      conn = put conn, bot_path(conn, :update, bot), bot: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Bot"
    end
  end

  describe "delete bot" do
    setup [:create_bot]

    test "deletes chosen bot", %{conn: conn, bot: bot} do
      conn = delete conn, bot_path(conn, :delete, bot)
      assert redirected_to(conn) == bot_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, bot_path(conn, :show, bot)
      end
    end
  end

  defp create_bot(_) do
    bot = fixture(:bot)
    {:ok, bot: bot}
  end
end
