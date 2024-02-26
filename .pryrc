# frozen_string_literal: true

ENV["RACK_ENV"] ||= "development"

Pry.config.hooks.add_hook(:when_started, :load_app) do
  puts "Using Ruby version #{RUBY_VERSION}"
  require "dotenv"
  Dotenv.load(".env.test", overwrite: true) if ENV["RACK_ENV"] == "test"
  load "orders/config.rb"
  load "orders/models.rb"
  load "orders/services.rb"
end
