defmodule ApiEcommerceWeb.Router do
  use ApiEcommerceWeb, :router

  alias ApiEcommerce.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.AuthPipeline
  end

  scope "/v1", ApiEcommerceWeb do
    pipe_through :api

    post "/users/sign_in", UserController, :sign_in
    post "/users/sign_up", UserController, :create
  end

  scope "/v1", ApiEcommerceWeb do
    pipe_through [:api, :auth]

    resources "/users", UserController, except: [:new, :create, :edit]
  end
end
