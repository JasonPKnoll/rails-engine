# frozen_string_literal: true

require 'rails_helper'

describe 'Merchant Potential API' do
  before(:each, :unshipped) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
    @merchant_4 = create(:merchant)

    @item_1 = create(:item, merchant_id: @merchant_1.id)
    @item_2 = create(:item, merchant_id: @merchant_2.id)
    @item_3 = create(:item, merchant_id: @merchant_3.id)
    @item_4 = create(:item, merchant_id: @merchant_4.id)

    @customer = create(:customer)

    @invoice_1 = create(:invoice, merchant_id: @merchant_1.id, customer_id: @customer.id, status: 'packaged')
    @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer.id, status: 'packaged')
    @invoice_3 = create(:invoice, merchant_id: @merchant_3.id, customer_id: @customer.id, status: 'packaged')
    @invoice_4 = create(:invoice, merchant_id: @merchant_4.id, customer_id: @customer.id, status: 'shipped')

    create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    create(:transaction, invoice_id: @invoice_2.id, result: 'success')
    create(:transaction, invoice_id: @invoice_3.id, result: 'success')
    create(:transaction, invoice_id: @invoice_4.id, result: 'success')

    create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: 100.0)
    create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 50, unit_price: 100.0)
    create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 20, unit_price: 100.0)
    create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_4.id, quantity: 25, unit_price: 100.0)
  end

  describe '::Find potential revenue for merchant' do
    describe '::Happy path' do
      it 'finds merchant revenue for orders that are unshipped', :unshipped do
        x = 3
        get "/api/v1/revenue/unshipped?quantity=#{x}"

        revenue = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(revenue[:data][0][:type]).to eq('unshipped_order')
        expect(revenue[:data][0][:attributes][:potential_revenue]).to eq(5000.0)
        expect(revenue[:data][1][:attributes][:potential_revenue]).to eq(2000.0)
        expect(revenue[:data][2][:attributes][:potential_revenue]).to eq(1000.0)
      end
    end
    describe '::Sad path' do
      it "defaults to finding 10 if no quantity is specified" do
        get "/api/v1/revenue/unshipped?"

        expect(response).to be_successful
      end
      it "requires quantity greater that 0" do
        get "/api/v1/revenue/unshipped?quantity=-2"
        expect(response.status).to eq(400)

        get "/api/v1/revenue/unshipped?quantity=0"
        expect(response.status).to eq(400)
      end
    end
  end
end
