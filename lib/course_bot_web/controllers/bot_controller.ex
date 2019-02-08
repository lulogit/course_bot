defmodule CourseBotWeb.BotController do
  use CourseBotWeb, :controller

  alias CourseBot.Chatbots
  alias CourseBot.Chatbots.Bot

  def index(conn, _params) do
    bots = Chatbots.list_bots()
    render(conn, "index.html", bots: bots)
  end

  def new(conn, _params) do
    changeset = Chatbots.change_bot(%Bot{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bot" => bot_params}) do
    case Chatbots.create_bot(bot_params) do
      {:ok, bot} ->
        conn
        |> put_flash(:info, "Bot created successfully.")
        |> redirect(to: bot_path(conn, :show, bot))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bot = Chatbots.get_bot!(id)
    render(conn, "show.html", bot: bot)
  end

  def edit(conn, %{"id" => id}) do
    bot = Chatbots.get_bot!(id)
    changeset = Chatbots.change_bot(bot)
    render(conn, "edit.html", bot: bot, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bot" => bot_params}) do
    bot = Chatbots.get_bot!(id)

    case Chatbots.update_bot(bot, bot_params) do
      {:ok, bot} ->
        conn
        |> put_flash(:info, "Bot updated successfully.")
        |> redirect(to: bot_path(conn, :show, bot))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bot: bot, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bot = Chatbots.get_bot!(id)
    {:ok, _bot} = Chatbots.delete_bot(bot)

    conn
    |> put_flash(:info, "Bot deleted successfully.")
    |> redirect(to: bot_path(conn, :index))
  end
end
