require "hanami/middleware/body_parser"
require_relative "boot"

class Api < Hanami::API
  use Hanami::Middleware::BodyParser, :json

  get "/hels" do
    Order.count.to_s
  rescue => exception
    "#{exception.class}: #{exception.message}"
  end

  post "/orders" do
    order, line_items = OrderCreator.call(params[:order])
    payment_session_url = PaymentInitiator.call(order, line_items)

    redirect payment_session_url, 303
  rescue => exception
    warn(exception.full_message)
    redirect SHOP_URL + "/error.html?error=#{CGI.escape(Utils.user_facing_error_message(exception))}", 303
  end

  get "/orders/success" do
    if Utils.token_param_correct_format?(params[:t])
      Order.pending.first(token: params[:t])&.mark_paid!
    end
    redirect SHOP_URL + "/success.html", 303
  end

  get "/orders/cancel" do
    if Utils.token_param_correct_format?(params[:t])
      Order.pending.first(token: params[:t])&.mark_canceled!
    end
    redirect SHOP_URL + "/cancel.html", 303
  end
end
