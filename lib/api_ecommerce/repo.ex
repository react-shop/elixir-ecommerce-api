defmodule ApiEcommerce.Repo do
  use Ecto.Repo,
    otp_app: :api_ecommerce,
    adapter: Ecto.Adapters.MyXQL
end
