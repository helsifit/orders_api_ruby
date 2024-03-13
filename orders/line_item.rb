class LineItem < Sequel::Model
  many_to_one :order

  def validate
    super
    errors.add(:unit_amount, "product variant is unknown") unless unit_amount
    errors.add(:quantity, "must be positive") unless quantity.positive?
  end

  def subtotal_amount
    quantity * unit_amount
  end

  def product_name
    PRODUCT_VARIANTS.fetch(product_variant_key).fetch("title")
  end
end
