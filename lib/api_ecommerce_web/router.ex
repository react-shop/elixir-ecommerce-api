defmodule ApiEcommerceWeb.Router do
  use ApiEcommerceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug :verify_auth
  end

  scope "/v1", ApiEcommerceWeb do
    pipe_through :api
    post "/users/sign_in", UserController, :sign_in
  end

  scope "/v1", ApiEcommerceWeb do
    pipe_through [:api]
    resources "/users", UserController, except: [:new, :edit]
  end

  # Plug function
  defp verify_auth(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(MyAppWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
    end
  end
end
