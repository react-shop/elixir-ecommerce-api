defmodule ApiEcommerceWeb.UserView do
  use ApiEcommerceWeb, :view
  alias ApiEcommerceWeb.UserView

  def render("index.json", %{users: users, user: user}) do
    %{
      data: render_many(users, UserView, "user.json"),
      user: user
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("sign_in.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, is_active: user.is_active}
  end
end
