defmodule FeelbotWeb.UserView do
  use FeelbotWeb, :view
  alias FeelbotWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      avatar: user.avatar,
      display_name: user.display_name,
      username: user.username}
  end
end
