FactoryBot.define do
  factory :transaction do
    # invoice { nil }
    credit_card_number { Faker::Stripe.valid_card }
    credit_card_expiration_date { Faker::Business.credit_card_expiry_date }
    result { "success" } # other option: fail
  end
end
