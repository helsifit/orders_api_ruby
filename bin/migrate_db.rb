#!/usr/bin/env ruby
# frozen_string_literal: true

# bin/migrate_db.rb -h127.0.0.1 -ualex -dhelsifit_orders_dev
# bin/migrate_db.rb -h127.0.0.1 -ualex -dhelsifit_orders_test

require "optparse"
require "pg"
require "sequel"

OPTIONS = {adapter: "postgresql", database: "orders_dev"}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby scripts/create_db.rb [OPTIONS]"
  opts.on("-hHOST", "--host HOST", "Database host") { |host| OPTIONS[:host] = host }
  opts.on("-uUSER", "--user USER", "Database username") { |user| OPTIONS[:user] = user }
  opts.on("-pPASSWORD", "--password PASSWORD", "Database password") { |password| OPTIONS[:password] = password }
  opts.on("-PPORT", "--port PORT", "Database port") { |port| OPTIONS[:port] = port }
  opts.on("-dDATABASE", "--database DATABASE", "Database name") { |db_name| OPTIONS[:database] = db_name }
end.parse!

Sequel.connect(OPTIONS) do |db|
  db.create_table? :product_variants do
    primary_key :id
    String :product_handle, index: true, null: false
    String :color
    String :size
    String :title, null: false
    String :stripe_product_id
    DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
    DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP, null: false, index: true

    index [:product_handle, :color, :size], unique: true, nulls_distinct: false
  end

  db.create_table? :prices do
    primary_key :id
    foreign_key :product_variant_id, :product_variants, null: false, on_delete: :restrict
    String :currency, null: false, limit: 7
    Integer :unit_amount, null: false
    String :stripe_price_id
    DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
    DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP, null: false, index: true

    index [:product_variant_id, :currency], unique: true
  end

  db.create_table? :orders do
    primary_key :id
    String :email
    String :country_code
    String :first_name
    String :last_name
    String :address1
    String :address2
    String :city
    String :zone
    String :postal_code
    String :currency, null: false, limit: 7
    Integer :total_amount
    Boolean :paid
    Boolean :canceled
    String :stripe_session_id
    uuid :token, null: false, index: true
    DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP, null: false
    DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP, null: false, index: true
  end

  db.create_table? :line_items do
    primary_key :id
    foreign_key :order_id, :orders, index: true, null: false, on_delete: :restrict
    foreign_key :price_id, :prices, null: false, on_delete: :restrict
    Integer :unit_amount, null: false
    Integer :quantity, null: false
  end
end
