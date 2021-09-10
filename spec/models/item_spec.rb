require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "class methods" do
    before(:each, :with_multi_items_rev) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)

      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_1.id)
      @item_3 = create(:item, merchant_id: @merchant_2.id)
      @item_4 = create(:item, merchant_id: @merchant_2.id)

      @customer = create(:customer)

      @invoice_1 = create(:invoice, merchant_id: @merchant_1.id, customer_id: @customer.id, status: "shipped")
      @invoice_2 = create(:invoice, merchant_id: @merchant_1.id, customer_id: @customer.id, status: "shipped")
      @invoice_3 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer.id, status: "shipped")
      @invoice_4 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer.id, status: "shipped")

      create(:transaction, invoice_id: @invoice_1.id, result: "success")
      create(:transaction, invoice_id: @invoice_2.id, result: "success")
      create(:transaction, invoice_id: @invoice_3.id, result: "success")
      create(:transaction, invoice_id: @invoice_4.id, result: "success")

      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 100.0)
      create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 55, unit_price: 100.0)
      create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 10, unit_price: 100.0)
      create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_4.id, quantity: 25, unit_price: 100.0)
    end

    it "find_all_by_name and list in order grabbing the first one" do
      merchant = create(:merchant)
      item_1 = create(:item, name: "Strawberry Donut", merchant_id: merchant.id)
      item_2 = create(:item, name: "Everything Bagel", merchant_id: merchant.id)
      item_3 = create(:item, name: "Glazed Donut", merchant_id: merchant.id)
      item_4 = create(:item, name: "Long John Donut", merchant_id: merchant.id)

      expect(Item.find_all_by_name("dOnU")).to eq([item_3, item_4, item_1])
    end

    it "find_most_revenue for items", :with_multi_items_rev do
      expect(Item.find_most_revenue(3)).to eq([@item_2, @item_4, @item_3])
    end
  end
end
