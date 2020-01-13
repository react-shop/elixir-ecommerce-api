defmodule EcommerceApiWeb.AuthView do
  use EcommerceApiWeb, :view
  alias EcommerceApiWeb.AuthView
  alias EcommerceApiWeb.UserView

  def render("sign_in.json", %{user: user, token: token}) do
    %{data: Map.merge(render_one(user, UserView, "user.json"), %{token: token})}
  end

  def render("sign_up.json", %{user: user, token: token}) do
    %{data: Map.merge(render_one(user, UserView, "user.json"), %{token: token})}
  end
end
