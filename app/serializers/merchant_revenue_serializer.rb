# frozen_string_literal: true

class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :revenue
end
