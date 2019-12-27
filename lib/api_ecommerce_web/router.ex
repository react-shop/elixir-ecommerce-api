defmodule ApiEcommerceWeb.Router do
  use ApiEcommerceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiEcommerceWeb do
    pipe_through :api
  end
end
