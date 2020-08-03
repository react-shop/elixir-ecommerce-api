# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api_ecommerce,
  ecto_repos: [ApiEcommerce.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :api_ecommerce, ApiEcommerceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xpSGNOCTXLgEQy1K1X+Q9aGfZZXx5Y37FxaXsUgrqf/zKk4KZwpPDCK0nWlUNrOh",
  render_errors: [view: ApiEcommerceWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: MyApp.PubSub

config :api_ecommerce, ApiEcommerce.Guardian,
  issuer: "api_ecommerce",
  secret_key: "RFl88y/O+rrGqRzWwdTGpsF68o07jhz60tfUnh0mTKhkGpeGo3Adzc8+xDuxXyd5"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
