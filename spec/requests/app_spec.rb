# frozen_string_literal: true

RSpec.describe "App", type: :request do
  let(:app) { App.new }
  let!(:product_variant) do
    ProductVariant.find_or_create(product_handle: "ab-roller", color: "blue") do |pv|
      pv.title = "Ab Roller, Blue"
      pv.stripe_product_id = "prod_PcJxLsYeYennfA"
    end
  end
  let!(:price) do
    Price.find_or_create(product_variant_id: product_variant.id, currency: "GBP") do |price|
      price.unit_amount = 5499
      price.stripe_price_id = "price_1On5K4JsbKv4DPOMbytvJUjw"
    end
  end
  let(:order) { Order.last }

  describe "create order" do
    let(:order_attributes) do
      {
        currency: price.currency,
        country_code: "GB",
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        address1: Faker::Address.street_address,
        address2: Faker::Address.building_number,
        city: Faker::Address.city,
        zone: "",
        postal_code: Faker::Address.postcode,
        line_items: [{
          product_handle: price.product_variant.product_handle,
          size: "",
          color: price.product_variant.color,
          quantity: 1
        }]
      }
    end

    it "creates order without PSP", vcr: {cassette_name: "stripe/create_session"} do
      post "/orders", {order: order_attributes}

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq({
        "id" => order.id,
        "currency" => "GBP",
        "total_amount" => 5499,
        "paid" => false,
        "line_items"=>[{"product_handle"=>"ab-roller", "quantity"=>1}]})
    end

    it "creates order and redirects to Stripe session", vcr: {cassette_name: "stripe/create_session"} do
      post "/orders", {order: order_attributes.merge(psp: "stripe")}

      expect(last_response).to be_redirect
      expect(last_response.headers["Location"]).to eq("https://checkout.stripe.com/c/pay/cs_test_a1q4FfXheTMfhhj0NzN0XxI9hcUOwGSQmcr2yfGGtlrlKuml0H90Fg44W2#fidqdXFsaGx2cWxmUmRpaWBxV2BrYWB3Jz9xd3BgKSdkdWxOYHwnPyd1blpxYHZxWjA0SmFzUENPdmdOczFBVUpIdV9ybUBTU0lJcjVJajZRaTdDY1xTYzdMQjU2Z3BuQmBvTkdzUUl%2FYTJHdjFGV2psYm9qcGJyf2xGVH9tSDB0fTZwNVx2STxSNTVVfzdOdU5%2FUCcpJ2N3amhWYHdzYHcnP3F3cGApJ2lkfGpwcVF8dWAnPyd2bGtiaWBabHFgaCcpJ2BrZGdpYFVpZGZgbWppYWB3dic%2FcXdwYHgl")
      expect(order.stripe_session_id).to eq("cs_test_a1q4FfXheTMfhhj0NzN0XxI9hcUOwGSQmcr2yfGGtlrlKuml0H90Fg44W2")
      expect(order.token).to_not be_nil
    end
  end

  describe "success callback" do
    it "marks order as paid and redirects to frontend success page" do
      get "/orders/success?t=#{order.token}"

      expect(order.reload.paid).to eql(true)
      expect(last_response).to be_redirect
      expect(last_response.headers["Location"]).to eq("http://localhost:9000/success.html")
    end
  end
end
