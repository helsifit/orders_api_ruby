#!/usr/bin/env ruby
# frozen_string_literal: true

# SHOP_ADMIN_URL=http://localhost:8000/ ruby scripts/sync_shop_admin_prices.rb

require_relative "../orders/config"
require_relative "../orders/models"
require "faraday"
require "json"
require "oj"
require "pry"

SHOP_ADMIN_URL = ENV.fetch("SHOP_ADMIN_URL", "http://localhost:8000")
SHOP_ADMIN_PRICES_URL = File.join(SHOP_ADMIN_URL, "/api/prices/")

response = Faraday.get(SHOP_ADMIN_PRICES_URL, {}, "Accept" => "application/json")
prices = JSON.parse(response.body, symbolize_names: true)[:prices]

product_handles = prices.map { _1[:product] }.uniq - ProductVariant.select_map(:product_handle)
Sequel::Model.db[:product_variants].import([:product_handle], product_handles) if product_handles.any?

PRODUCT_IDS = ProductVariant.all.each_with_object({}) { |prod, m| m[prod.handle] = prod.id }.freeze

Sequel::Model.db[:prices].insert_conflict.import(
  %i[product_variant_id product_handle size currency unit_amount],
  prices.map do |price|
    [PRODUCT_IDS.fetch(price[:product]), price[:product_handle], price[:size], price[:currency], price[:price] * 100]
  end
)
