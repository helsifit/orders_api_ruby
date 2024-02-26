# frozen_string_literal: true

require "bundler"
Bundler.require(:default, ENV.fetch("RACK_ENV"))

Stripe.api_key = ENV.fetch("STRIPE_API_KEY")
STORE_URL = ENV.fetch("STORE_URL", "http://localhost:9000")
ORDERS_URL = ENV.fetch("ORDERS_URL", "http://localhost:3000")
DB_CONFIG = {
  adapter: "postgresql",
  host: ENV.fetch("DB_HOST", "127.0.0.1"),
  port: ENV.fetch("DB_PORT", "5432"),
  pool: ENV.fetch("DB_POOL", "5"),
  username: ENV.fetch("DB_USERNAME"),
  password: ENV.fetch("DB_PASSWORD"),
  database: ENV.fetch("DB_DATABASE")
}.freeze
Sequel::Model.db = DB = Sequel.connect(DB_CONFIG)
