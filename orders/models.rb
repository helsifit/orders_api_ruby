# frozen_string_literal: true

class ProductVariant < Sequel::Model
  one_to_many :prices
end

class Price < Sequel::Model
  many_to_one :product_variant
end

class Order < Sequel::Model
  CURRENCIES = %w[USD GBP AUD CAD EUR NZD].freeze
  STRIPE = "stripe"
  plugin :uuid, field: :token
  one_to_many :line_items

  def validate
    super
    errors.add(:currency, "cannot be used at this moment") if !currency || currency.empty? || !CURRENCIES.include?(currency)
    errors.add(:country_code, "cannot be empty") if !country_code || country_code.empty?
    errors.add(:first_name, "cannot be empty") if !first_name || first_name.empty?
    errors.add(:last_name, "cannot be empty") if !last_name || last_name.empty?
    errors.add(:address1, "cannot be empty") if !address1 || address1.empty?
    errors.add(:city, "cannot be empty") if !city || city.empty?
    errors.add(:zone, "cannot be empty") if country_code == "US" && (!zone || zone.empty?)
    errors.add(:postal_code, "cannot be empty") if !postal_code || postal_code.empty?
  end
end

class LineItem < Sequel::Model
  many_to_one :order
  many_to_one :price

  def validate
    super
    errors.add(:price, "product variant price is unknown") unless price_id
  end

  def subtotal_amount
    quantity * unit_amount
  end
end
