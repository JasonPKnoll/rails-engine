require "rails_helper"

describe "Items Rev API" do
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

  describe "::Find revenue of single merchant" do
    describe "::Happy path" do
      it "finds merchants with most revenue", :with_multi_items_rev do
        x = 3
        get "/api/v1/revenue/items?quantity=#{x}"

        revenue = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(revenue[:data][0][:type]).to eq("item_revenue")
        expect(revenue[:data][0][:attributes][:name]).to eq(@item_2.name)
        expect(revenue[:data][1][:attributes][:name]).to eq(@item_4.name)
        expect(revenue[:data][2][:attributes][:name]).to eq(@item_3.name)
      end
    end
    describe "::Sad Path" do
      it "error 400" do
        get "/api/v1/revenue/items?quantity=-1"

        expect(response.status).to eq(400)
      end
    end
  end
end
