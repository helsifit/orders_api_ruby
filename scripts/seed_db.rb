#!/usr/bin/env ruby
# frozen_string_literal: true

# ruby scripts/seed_db.rb
# DB_DATABASE=helsifit_orders_test ruby scripts/seed_db.rb

require_relative "../orders/config"

blue_ab_roller_id = DB[:product_variants].insert_conflict.insert(
  title: "HelsiFit™ Ab Roller Wheel Automatic Rebound With Elbow Support\nBlue",
  product_handle: "ab-roller",
  color: "blue"
) || DB[:product_variants].where(product_handle: "ab-roller", color: "blue").get(:id)
orange_ab_roller_id = DB[:product_variants].insert_conflict.insert(
  title: "HelsiFit™ Ab Roller Wheel Automatic Rebound With Elbow Support\nOrange",
  product_handle: "ab-roller",
  color: "orange"
) || DB[:product_variants].where(product_handle: "ab-roller", color: "orange").get(:id)
push_up_board_id = DB[:product_variants].insert_conflict.insert(
  title: "HelsiFit™ Multifunctional Push-Up Board 14-in-1",
  product_handle: "push-up-board"
) || DB[:product_variants].where(product_handle: "push-up-board").get(:id)
priority_shipping_id = DB[:product_variants].insert_conflict.insert(
  title: "Shipping",
  product_handle: "priority-shipping"
) || DB[:product_variants].where(product_handle: "priority-shipping").get(:id)

DB[:prices].insert_conflict.insert(product_variant_id: blue_ab_roller_id, currency: "USD", unit_amount: 6999)
DB[:prices].insert_conflict.insert(product_variant_id: blue_ab_roller_id, currency: "GBP", unit_amount: 5499)
DB[:prices].insert_conflict.insert(product_variant_id: blue_ab_roller_id, currency: "AUD", unit_amount: 10699)
DB[:prices].insert_conflict.insert(product_variant_id: blue_ab_roller_id, currency: "CAD", unit_amount: 9399)
DB[:prices].insert_conflict.insert(product_variant_id: blue_ab_roller_id, currency: "EUR", unit_amount: 6499)
DB[:prices].insert_conflict.insert(product_variant_id: blue_ab_roller_id, currency: "NZD", unit_amount: 11499)
DB[:prices].insert_conflict.insert(product_variant_id: orange_ab_roller_id, currency: "USD", unit_amount: 6999)
DB[:prices].insert_conflict.insert(product_variant_id: orange_ab_roller_id, currency: "GBP", unit_amount: 5499)
DB[:prices].insert_conflict.insert(product_variant_id: orange_ab_roller_id, currency: "AUD", unit_amount: 10699)
DB[:prices].insert_conflict.insert(product_variant_id: orange_ab_roller_id, currency: "CAD", unit_amount: 9399)
DB[:prices].insert_conflict.insert(product_variant_id: orange_ab_roller_id, currency: "EUR", unit_amount: 6499)
DB[:prices].insert_conflict.insert(product_variant_id: orange_ab_roller_id, currency: "NZD", unit_amount: 11499)
DB[:prices].insert_conflict.insert(product_variant_id: push_up_board_id, currency: "USD", unit_amount: 4599)
DB[:prices].insert_conflict.insert(product_variant_id: push_up_board_id, currency: "GBP", unit_amount: 3599)
DB[:prices].insert_conflict.insert(product_variant_id: push_up_board_id, currency: "AUD", unit_amount: 6999)
DB[:prices].insert_conflict.insert(product_variant_id: push_up_board_id, currency: "CAD", unit_amount: 6199)
DB[:prices].insert_conflict.insert(product_variant_id: push_up_board_id, currency: "EUR", unit_amount: 4299)
DB[:prices].insert_conflict.insert(product_variant_id: push_up_board_id, currency: "NZD", unit_amount: 7499)
DB[:prices].insert_conflict.insert(product_variant_id: priority_shipping_id, currency: "USD", unit_amount: 399)
DB[:prices].insert_conflict.insert(product_variant_id: priority_shipping_id, currency: "GBP", unit_amount: 299)
DB[:prices].insert_conflict.insert(product_variant_id: priority_shipping_id, currency: "AUD", unit_amount: 599)
DB[:prices].insert_conflict.insert(product_variant_id: priority_shipping_id, currency: "CAD", unit_amount: 599)
DB[:prices].insert_conflict.insert(product_variant_id: priority_shipping_id, currency: "EUR", unit_amount: 399)
DB[:prices].insert_conflict.insert(product_variant_id: priority_shipping_id, currency: "NZD", unit_amount: 699)
