require "bundler"
Bundler.require(:default, ENV.fetch("RACK_ENV", "development"))

Stripe.api_key = ENV.fetch("STRIPE_API_KEY")
SHOP_URL = ENV.fetch("SHOP_URL", "http://localhost:9000")
ORDERS_URL = ENV.fetch("ORDERS_URL", "http://localhost:3000")
DB_CONFIG = {
  adapter: "postgresql",
  host: ENV.fetch("DB_HOST", "127.0.0.1"),
  port: ENV.fetch("DB_PORT", "5432"),
  pool: ENV.fetch("DB_POOL", "5"),
  username: ENV.fetch("DB_USERNAME", "alex"),
  password: ENV.fetch("DB_PASSWORD", ""),
  database: ENV.fetch("DB_DATABASE", "helsifit_orders_dev")
}.freeze
Sequel::Model.db = DB = Sequel.connect(DB_CONFIG)
