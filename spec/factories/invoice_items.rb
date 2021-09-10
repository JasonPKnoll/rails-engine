# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_item do
    # item { Faker::Food.dish }
    # invoice { Faker::Invoice.reference }
    quantity { Faker::Number.within(range: 1..25) }
    unit_price { Faker::Number.within(range: 1000..100_000) }
  end
end
