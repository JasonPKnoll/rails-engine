# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    # customer { nil }
    # merchant { nil }
    status { 'shipped' } # other options: failed, pending
  end
end
