#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../orders/config"

Sequel.connect(DB_CONFIG.except(:database)) do |db|
  db.execute "CREATE DATABASE #{DB_CONFIG[:database]}"
end
