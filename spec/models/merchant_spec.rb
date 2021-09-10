require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before(:each, :with_multi_merchants_rev) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
    @merchant_4 = create(:merchant)

    @item_1 = create(:item, merchant_id: @merchant_1.id)
    @item_2 = create(:item, merchant_id: @merchant_2.id)
    @item_3 = create(:item, merchant_id: @merchant_3.id)
    @item_4 = create(:item, merchant_id: @merchant_4.id)

    @customer = create(:customer)

    @invoice_1 = create(:invoice, merchant_id: @merchant_1.id, customer_id: @customer.id, status: "shipped")
    @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer.id, status: "shipped")
    @invoice_3 = create(:invoice, merchant_id: @merchant_3.id, customer_id: @customer.id, status: "shipped")
    @invoice_4 = create(:invoice, merchant_id: @merchant_4.id, customer_id: @customer.id, status: "shipped")

    create(:transaction, invoice_id: @invoice_1.id, result: "success")
    create(:transaction, invoice_id: @invoice_2.id, result: "success")
    create(:transaction, invoice_id: @invoice_3.id, result: "success")
    create(:transaction, invoice_id: @invoice_4.id, result: "success")

    create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 100.0)
    create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 55, unit_price: 100.0)
    create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 10, unit_price: 100.0)
    create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_4.id, quantity: 25, unit_price: 100.0)
  end

  describe "class methods" do
    it "::find_by_name and list in order grabbing the first one" do
      merchant_1 = create(:merchant, name: "Biggie Smalls")
      merchant_2 = create(:merchant, name: "Big Chungus")
      merchant_3 = create(:merchant, name: "Mike")

      expect(Merchant.find_by_name("Big")).to eq(merchant_2)
    end

    it "::find_merchant_rev:: finds the merchants revenue" do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      customer = create(:customer)

      invoices = []
      invoices << create_list(:invoice, 3, merchant_id: merchant.id, customer_id: customer.id, status: "shipped")
      invoices << create_list(:invoice, 1, merchant_id: merchant.id, customer_id: customer.id, status: "pending")
      invoices = invoices.flatten

      create(:transaction, invoice_id: invoices[0].id, result: "success")
      create(:transaction, invoice_id: invoices[1].id, result: "failed")
      create(:transaction, invoice_id: invoices[2].id, result: "success")
      create(:transaction, invoice_id: invoices[3].id, result: "success")

      create(:invoice_item, item_id: item.id, invoice_id: invoices[0].id, quantity: 10, unit_price: 100.0)
      create(:invoice_item, item_id: item.id, invoice_id: invoices[1].id, quantity: 10, unit_price: 100.0)
      create(:invoice_item, item_id: item.id, invoice_id: invoices[2].id, quantity: 20, unit_price: 100.0)
      create(:invoice_item, item_id: item.id, invoice_id: invoices[3].id, quantity: 10, unit_price: 100.0)

      expect(merchant.find_merchant_rev).to eq(3000.0)
    end

    it "::find_most_revenue:: finds the merchants with highest revenues", :with_multi_merchants_rev do
      expect(Merchant.find_most_revenue(3)).to eq([@merchant_2, @merchant_4, @merchant_3])
    end
  end
end
