# frozen_string_literal: true

module OrderCreator
  def self.call(opts)
    opts[:zone] = nulify_string(opts[:zone])
    opts[:address2] = nulify_string(opts[:address2])
    order = Order.create(opts.slice(:currency, :country_code, :first_name, :last_name, :address1, :address2, :city, :zone, :postal_code))
    pv = Sequel[:product_variants]
    line_items = opts[:line_items].map do |h|
      product_handle = nulify_string(h[:product_handle])
      size = nulify_string(h[:size])
      color = nulify_string(h[:color])
      price = Price
        .join(:product_variants, id: :product_variant_id)
        .first(pv[:product_handle] => product_handle, pv[:size] => size, pv[:color] => color, :currency => order.currency)
      LineItem.create(order:, price:, quantity: h[:quantity].to_i, unit_amount: price.unit_amount)
    end
    order.update(total_amount: line_items.map(&:subtotal_amount).sum)
    [order, line_items]
  end

  def self.nulify_string(val)
    (val.is_a?(String) && !val.empty?) ? val : nil
  end
end
