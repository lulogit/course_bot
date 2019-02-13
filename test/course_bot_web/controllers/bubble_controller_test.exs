defmodule CourseBotWeb.BubbleControllerTest do
  use CourseBotWeb.ConnCase

  alias CourseBot.Bubbles

  @create_attrs %{convo: "some convo", name: "some name"}
  @update_attrs %{convo: "some updated convo", name: "some updated name"}
  @invalid_attrs %{convo: nil, name: nil}

  def fixture(:bubble) do
    {:ok, bubble} = Bubbles.create_bubble(@create_attrs)
    bubble
  end

  describe "index" do
    test "lists all bubbles", %{conn: conn} do
      conn = get conn, bubble_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Bubbles"
    end
  end

  describe "new bubble" do
    test "renders form", %{conn: conn} do
      conn = get conn, bubble_path(conn, :new)
      assert html_response(conn, 200) =~ "New Bubble"
    end
  end

  describe "create bubble" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, bubble_path(conn, :create), bubble: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == bubble_path(conn, :show, id)

      conn = get conn, bubble_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Bubble"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, bubble_path(conn, :create), bubble: @invalid_attrs
      assert html_response(conn, 200) =~ "New Bubble"
    end
  end

  describe "edit bubble" do
    setup [:create_bubble]

    test "renders form for editing chosen bubble", %{conn: conn, bubble: bubble} do
      conn = get conn, bubble_path(conn, :edit, bubble)
      assert html_response(conn, 200) =~ "Edit Bubble"
    end
  end

  describe "update bubble" do
    setup [:create_bubble]

    test "redirects when data is valid", %{conn: conn, bubble: bubble} do
      conn = put conn, bubble_path(conn, :update, bubble), bubble: @update_attrs
      assert redirected_to(conn) == bubble_path(conn, :show, bubble)

      conn = get conn, bubble_path(conn, :show, bubble)
      assert html_response(conn, 200) =~ "some updated convo"
    end

    test "renders errors when data is invalid", %{conn: conn, bubble: bubble} do
      conn = put conn, bubble_path(conn, :update, bubble), bubble: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Bubble"
    end
  end

  describe "delete bubble" do
    setup [:create_bubble]

    test "deletes chosen bubble", %{conn: conn, bubble: bubble} do
      conn = delete conn, bubble_path(conn, :delete, bubble)
      assert redirected_to(conn) == bubble_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, bubble_path(conn, :show, bubble)
      end
    end
  end

  defp create_bubble(_) do
    bubble = fixture(:bubble)
    {:ok, bubble: bubble}
  end
end
