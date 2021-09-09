require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "class methods" do
    it "find_by_name and list in order grabbing the first one" do
      merchant_1 = create(:merchant, name: "Biggie Smalls")
      merchant_2 = create(:merchant, name: "Big Chungus")
      merchant_3 = create(:merchant, name: "Mike")

      expect(Merchant.find_by_name("Big")).to eq(merchant_2)
    end
  end
end
