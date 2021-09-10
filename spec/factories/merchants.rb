# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    name { Faker::FunnyName.name }
  end
end
