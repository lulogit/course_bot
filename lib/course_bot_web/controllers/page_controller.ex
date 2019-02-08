defmodule CourseBotWeb.PageController do
  use CourseBotWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
