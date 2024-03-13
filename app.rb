require "hanami/middleware/body_parser"
require_relative "orders/boot"

class App < Hanami::API
  use Hanami::Middleware::BodyParser, :json

  get "/hels" do
    Order.count.to_s
  rescue => e
    "#{e.class}: #{e.message}"
  end

  post "/orders" do
    order, line_items = OrderCreator.call(params[:order])

    if order.psp == Order::STRIPE
      session = StripeSession.create(order, line_items)
      redirect session.url, 303
    else
      json({id: order.id, country_code: order.country_code, currency: order.currency, total_amount: order.total_amount,
        line_items: order.line_items.map { |li| {product_variant_key: li.product_variant_key, unit_amount: li.unit_amount, quantity: li.quantity} }})
    end
  rescue Sequel::ValidationFailed => e
    redirect SHOP_URL + "/error.html?error=#{CGI.escape(e.message)}", 303
  rescue => e
    warn(e.full_message)
    redirect SHOP_URL + "/error.html?error=Unexpected+error", 303
  end

  get "/orders/success" do
    Order.first(token: params[:t], canceled: false, paid: false)&.update(paid: true, updated_at: Time.now.utc) if params[:t].is_a?(String) && params[:t].size == 36

    redirect SHOP_URL + "/success.html", 303
  end

  get "/orders/cancel" do
    Order.first(token: params[:t], canceled: false, paid: false)&.update(canceled: true, updated_at: Time.now.utc) if params[:t].is_a?(String) && params[:t].size == 36

    redirect SHOP_URL + "/cancel.html", 303
  end
end
