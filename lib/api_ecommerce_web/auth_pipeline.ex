defmodule EcommerceApi.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :ecommerce_api,
                              module: EcommerceApi.Guardian,
                              error_handler: EcommerceApi.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end