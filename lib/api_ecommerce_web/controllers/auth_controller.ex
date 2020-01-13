defmodule EcommerceApiWeb.AuthController do
  use EcommerceApiWeb, :controller

  alias EcommerceApi.Accounts
  alias EcommerceApi.Accounts.User
  alias EcommerceApi.Guardian

  action_fallback EcommerceApiWeb.FallbackController

  def sign_up(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("sign_up.json", user: user, token: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password} = _params) do
    case EcommerceApi.Accounts.authenticate_user(email, password) do
      {:ok, user, token} ->
        conn
        |> put_status(:ok)
        |> render("sign_in.json", user: user, token: token)

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(EcommerceApiWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end
end
