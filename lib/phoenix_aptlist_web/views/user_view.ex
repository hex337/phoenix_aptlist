defmodule PhoenixAptlistWeb.UserView do
  use PhoenixAptlistWeb, :view
  alias PhoenixAptlistWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("index_for_slack.json", %{users: users}) do
    users_string = Enum.map_join(users, "\n", fn(x) -> "[#{x.id}] #{x.name} (#{x.email})" end)
    %{text: "Found users:\n#{users_string}"}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.txt", %{user: user}) do
    "#{user.name} (#{user.email})\n"
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email}
  end
end
