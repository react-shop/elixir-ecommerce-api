use Mix.Config

# Configure your database
config :api_ecommerce, ApiEcommerce.Repo,
  username: "admin",
  password: "admin",
  database: "api_ecommerce_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api_ecommerce, ApiEcommerceWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, :log_rounds, 4