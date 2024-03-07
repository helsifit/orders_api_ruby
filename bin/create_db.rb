#!/usr/bin/env ruby
# frozen_string_literal: true

# bundle exec ruby bin/create_db.rb
# docker exec -it orders-container bin/create_db.rb

begin
  require_relative "../orders/config"
  puts "Database #{DB_CONFIG[:database]} already exists."

rescue Sequel::DatabaseConnectionError => e
  puts "Creating database #{DB_CONFIG[:database]}..."

  Sequel.connect(DB_CONFIG.except(:database)) do |db|
    db.execute "CREATE DATABASE #{DB_CONFIG[:database]}"
  end
  puts "Created database #{DB_CONFIG[:database]}."
end
