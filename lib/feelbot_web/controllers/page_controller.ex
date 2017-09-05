defmodule FeelbotWeb.PageController do
  use FeelbotWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
