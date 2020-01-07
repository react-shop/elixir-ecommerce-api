defmodule ApiEcommerce.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :api_ecommerce,
                              module: ApiEcommerce.Guardian,
                              error_handler: ApiEcommerce.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end