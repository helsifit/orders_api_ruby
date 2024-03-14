class LineItem < Sequel::Model
  many_to_one :order

  def subtotal_amount
    quantity * unit_amount
  end

  def product_name
    PRODUCT_VARIANTS.fetch(product_variant_key).fetch("title")
  end
end
