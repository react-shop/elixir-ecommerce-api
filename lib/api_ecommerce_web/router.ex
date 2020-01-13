defmodule EcommerceApiWeb.Router do
  use EcommerceApiWeb, :router

  alias EcommerceApi.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.AuthPipeline
  end

  scope "/v1", EcommerceApiWeb do
    pipe_through :api

    post "/auth/sign_in", AuthController, :sign_in
    post "/auth/sign_up", AuthController, :sign_up
    post "/auth/forgot_password", AuthController, :forgot_password
  end

  scope "/v1", EcommerceApiWeb do
    pipe_through [:api, :auth]

    resources "/users", UserController, except: [:new, :create, :edit]
  end
end
