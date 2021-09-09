require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "class methods" do
    it "find_all_by_name and list in order grabbing the first one" do
      merchant = create(:merchant)
      item_1 = create(:item, name: "Strawberry Donut", merchant_id: merchant.id)
      item_2 = create(:item, name: "Everything Bagel", merchant_id: merchant.id)
      item_3 = create(:item, name: "Glazed Donut", merchant_id: merchant.id)
      item_4 = create(:item, name: "Long John Donut", merchant_id: merchant.id)

      expect(Item.find_all_by_name("dOnU")).to eq([item_3, item_4, item_1])
    end
  end
end
