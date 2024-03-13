RSpec.describe "App", type: :request do
  let(:app) { App.new }
  let(:order) { Order.last }

  describe "create order" do
    let(:order_attributes) do
      {
        psp: "dummy",
        currency: "GBP",
        country_code: "GB",
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        address1: Faker::Address.street_address,
        address2: Faker::Address.building_number,
        city: Faker::Address.city,
        zone: "",
        postal_code: Faker::Address.postcode,
        line_items: [{
          product_variant: "ab-roller/blue",
          quantity: 1
        }]
      }
    end

    it "creates order with dummy PSP" do
      post "/orders", order: order_attributes

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq({
        "id" => order.id,
        "country_code" => "GB",
        "currency" => "GBP",
        "total_amount" => 5499,
        "line_items" => [{"product_variant_key" => "ab-roller/blue", "unit_amount" => 5499, "quantity" => 1}]
      })
    end

    it "creates order and redirects to Stripe session", vcr: {cassette_name: "stripe/create_session"} do
      post "/orders", order: order_attributes.merge(psp: "stripe")

      expect(last_response).to be_redirect
      expect(last_response.headers["Location"]).to start_with("https://checkout.stripe.com/c/pay/cs_test_")
      expect(order.stripe_session_id).to start_with("cs_test_")
      expect(order.token).to_not be_nil
    end

    context "invalid data" do
      context "invalid currency" do
        it "redirects with error" do
          post "/orders", order: order_attributes.merge(currency: "EEE")

          expect(last_response).to be_redirect
          expect(last_response.headers["Location"]).to eq("http://localhost:9000/error.html?error=currency+cannot+be+used+at+this+moment")
        end
      end

      context "invalid product_variant" do
        it "redirects with error" do
          post "/orders", order: order_attributes.merge(line_items: [{product_variant: "sombrero", quantity: 1}])

          expect(last_response).to be_redirect
          expect(last_response.headers["Location"]).to eq("http://localhost:9000/error.html?error=Unexpected+error")
        end
      end
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
