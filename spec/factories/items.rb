FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    unit_price { Faker::Number.within(range: 1.0..100.0) }
    # merchant { nil }
  end
end
