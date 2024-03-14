RSpec.describe "Api", type: :request do
  let(:app) { Api.new }
  let(:order) { Order.last }

  describe "create order" do
    let(:order_attributes) do
      {
        psp: "debug",
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

    context "valid order data" do
      it "creates order with debug PSP" do
        post "/orders", order: order_attributes

        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/success.html")
        expect(order.total_amount).to eq(5499)
        expect(order.token).to_not be_nil
        expect(order.stripe_session_id).to be_nil
      end

      it "creates order and redirects to Stripe session", vcr: {cassette_name: "stripe/create_session"} do
        post "/orders", order: order_attributes.merge(psp: "stripe")

        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to start_with("https://checkout.stripe.com/c/pay/cs_test_")
        expect(order.total_amount).to eq(5499)
        expect(order.token).to_not be_nil
        expect(order.stripe_session_id).to start_with("cs_test_")
      end
    end

    context "invalid order data" do
      it "redirects with error when invalid currency" do
        post "/orders", order: order_attributes.merge(currency: "EEE")

        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/error.html?error=currency+cannot+be+used+at+this+moment")
      end

      it "redirects with error when invalid product_variant" do
        post "/orders", order: order_attributes.merge(line_items: [{product_variant: "sombrero", quantity: 1}])

        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/error.html?error=Unexpected+error")
      end
    end
  end

  describe "success callback" do
    context "pending order" do
      it "marks order as paid and redirects to frontend success page" do
        order.update(paid: false, canceled: false, updated_at: Time.now.utc - 86400)
        get "/orders/success?t=#{order.token}"

        expect(order.reload.paid).to eql(true)
        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/success.html")
      end
    end

    context "paid order" do
      it "does not update order and redirects to frontend success page" do
        order.update(paid: true, canceled: false, updated_at: Time.now.utc - 86400)
        expect {
          get "/orders/success?t=#{order.token}"
        }.not_to change { order.reload.updated_at }

        expect(order.reload.paid).to eql(true)
        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/success.html")
      end
    end

    context "canceled order" do
      it "does not update order and redirects to frontend success page" do
        order.update(paid: false, canceled: true, updated_at: Time.now.utc - 86400)
        expect {
          get "/orders/success?t=#{order.token}"
        }.not_to change { order.reload.updated_at }

        expect(order.reload.paid).to eql(false)
        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/success.html")
      end
    end
  end

  describe "callback to cancel order" do
    context "pending order" do
      it "marks order as paid and redirects to frontend success page" do
        order.update(paid: false, canceled: false, updated_at: Time.now.utc - 86400)
        get "/orders/cancel?t=#{order.token}"

        expect(order.reload.paid).to eql(false)
        expect(order.reload.canceled).to eql(true)
        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/cancel.html")
      end
    end

    context "paid order" do
      it "does not update order and redirects to frontend success page" do
        order.update(paid: true, canceled: false, updated_at: Time.now.utc - 86400)
        expect {
          get "/orders/cancel?t=#{order.token}"
        }.not_to change { order.reload.updated_at }

        expect(order.reload.paid).to eql(true)
        expect(order.reload.canceled).to eql(false)
        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/cancel.html")
      end
    end

    context "canceled order" do
      it "does not update order and redirects to frontend success page" do
        order.update(paid: false, canceled: true, updated_at: Time.now.utc - 86400)
        expect {
          get "/orders/cancel?t=#{order.token}"
        }.not_to change { order.reload.updated_at }

        expect(order.reload.paid).to eql(false)
        expect(order.reload.canceled).to eql(true)
        expect(last_response).to be_redirect
        expect(last_response.headers["Location"]).to eq("http://localhost:9000/cancel.html")
      end
    end
  end
end
