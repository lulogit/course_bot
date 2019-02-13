defmodule CourseBotWeb.BubbleController do
  use CourseBotWeb, :controller

  alias CourseBot.Bubbles
  alias CourseBot.Bubbles.Bubble
  alias Coursebot.Botpiler

  def index(conn, _params) do
    bubbles = Bubbles.list_bubbles()
    render(conn, "index.html", bubbles: bubbles)
  end

  def new(conn, _params) do
    changeset = Bubbles.change_bubble(%Bubble{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bubble" => bubble_params}) do
    convo = Botpiler.as_convo(bubble_params["conversations"].path)
    case Bubbles.create_bubble(Map.put(bubble_params, "convo", convo)) do
      {:ok, bubble} ->
        conn
        |> put_flash(:info, "Bubble created successfully.")
        |> redirect(to: bubble_path(conn, :show, bubble))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bubble = Bubbles.get_bubble!(id)
    render(conn, "show.html", bubble: bubble)
  end

  def edit(conn, %{"id" => id}) do
    bubble = Bubbles.get_bubble!(id)
    changeset = Bubbles.change_bubble(bubble)
    render(conn, "edit.html", bubble: bubble, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bubble" => bubble_params}) do
    bubble = Bubbles.get_bubble!(id)
    convo = Botpiler.as_convo(bubble_params["conversations"].path)

    case Bubbles.update_bubble(bubble, Map.put(bubble_params, "convo", convo)) do
      {:ok, bubble} ->
        conn
        |> put_flash(:info, "Bubble updated successfully.")
        |> redirect(to: bubble_path(conn, :show, bubble))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bubble: bubble, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bubble = Bubbles.get_bubble!(id)
    {:ok, _bubble} = Bubbles.delete_bubble(bubble)

    conn
    |> put_flash(:info, "Bubble deleted successfully.")
    |> redirect(to: bubble_path(conn, :index))
  end
end
