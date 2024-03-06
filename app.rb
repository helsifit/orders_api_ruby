# frozen_string_literal: true

require "hanami/middleware/body_parser"
require_relative "orders/boot"

class App < Hanami::API
  use Hanami::Middleware::BodyParser, :json

  get "/hels" do
    Order.count.to_s
  rescue => e
    "#{e.class} #{e.message}"
  end

  post "/orders" do
    order, line_items = OrderCreator.call(params[:order])

    if params[:order][:psp] == Order::STRIPE
      session = Stripe::Checkout::Session.create(
        line_items: line_items.map { {price: _1.price.stripe_price_id, quantity: _1.quantity} },
        mode: "payment",
        success_url: ORDERS_URL + "/orders/success?t=" + order.token,
        cancel_url: ORDERS_URL + "/orders/cancel?t=" + order.token
      )
      order.update(stripe_session_id: session.id, updated_at: Time.now.utc)

      redirect session.url, 303
    else
      json({id: order.id, currency: order.currency, total_amount: order.total_amount, paid: !!order.paid,
        line_items: order.line_items.map { |li| {product_handle: li.price.product_variant.product_handle, quantity: li.quantity} }})
    end
  rescue => e
    redirect SHOP_URL + "/error.html?error=#{CGI.escape(e.full_message)}", 303
  end

  get "/orders/success" do
    Order.first(token: params[:t])&.update(paid: true, updated_at: Time.now.utc)

    redirect SHOP_URL + "/success.html", 303
  end

  get "/orders/cancel" do
    Order.first(token: params[:t])&.update(canceled: true, updated_at: Time.now.utc)

    redirect SHOP_URL + "/cancel.html", 303
  end
end
