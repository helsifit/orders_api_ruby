#!/usr/bin/env ruby
# frozen_string_literal: true

# ruby scripts/sync_stripe_products.rb

require_relative "../orders/config"
require_relative "../orders/models"

# product = Product.first(handle: "ab-roller", color: "blue")
ProductVariant.where(stripe_product_id: nil).each do |product_variant|
  stripe_product = Stripe::Product.create(name: product_variant.title)

  product_variant.update(stripe_product_id: stripe_product.id, updated_at: Time.now.utc)
end

# price = Price.first(id: 1)
Price.eager(:artist).where(stripe_price_id: nil).each do |price|
  stripe_price = Stripe::Price.create(
    currency: price.currency,
    unit_amount: price.unit_amount,
    product: price.product_variant.stripe_product_id
  )

  price.update(stripe_price_id: stripe_price.id, updated_at: Time.now.utc)
end
