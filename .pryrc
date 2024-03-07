# frozen_string_literal: true

ENV["RACK_ENV"] ||= "development"

Pry.config.hooks.add_hook(:when_started, :load_app) do
  puts "Using Ruby version #{RUBY_VERSION}"
  require "dotenv" if ENV["RACK_ENV"] == "development" || ENV["RACK_ENV"] == "test"
  Dotenv.load(".env.test", overwrite: true) if ENV["RACK_ENV"] == "test"
  load "orders/boot.rb"
end
