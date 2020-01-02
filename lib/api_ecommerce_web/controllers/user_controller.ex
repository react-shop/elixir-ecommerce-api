defmodule ApiEcommerceWeb.UserController do
  use ApiEcommerceWeb, :controller

  alias ApiEcommerce.Auth
  alias ApiEcommerce.Auth.User

  action_fallback ApiEcommerceWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    user = get_session(conn, :current_user_id)
    render(conn, "index.json", users: users, user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case ApiEcommerce.Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> put_view(ApiEcommerceWeb.UserView)
        |> render("sign_in.json", user: user)

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ApiEcommerceWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end
end
