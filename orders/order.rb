class Order < Sequel::Model
  CURRENCIES = %w[USD GBP AUD CAD EUR NZD].freeze
  STRIPE = "stripe"
  plugin :uuid, field: :token
  one_to_many :line_items
  dataset_module do
    def pending
      where(paid: false, canceled: false)
    end
  end

  def mark_paid!
    update(paid: true, updated_at: Time.now.utc)
  end

  def mark_canceled!
    update(canceled: true, updated_at: Time.now.utc)
  end
end
