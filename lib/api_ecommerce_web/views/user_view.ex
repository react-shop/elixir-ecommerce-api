defmodule ApiEcommerceWeb.UserView do
  use ApiEcommerceWeb, :view
  alias ApiEcommerceWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("sign_in.json", %{user: user, token: token}) do
    %{data: Map.merge(render_one(user, UserView, "user.json"), %{token: token})}
  end

  def render("sign_up.json", %{user: user, token: token}) do
    %{data: Map.merge(render_one(user, UserView, "user.json"), %{token: token})}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      role: user.role,
      status: user.status
    }
  end
end
