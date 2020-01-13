defmodule EcommerceApi.Repo do
  use Ecto.Repo,
    otp_app: :ecommerce_api,
    adapter: Ecto.Adapters.MyXQL
end
