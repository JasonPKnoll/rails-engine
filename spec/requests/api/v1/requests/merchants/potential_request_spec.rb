# frozen_string_literal: true

require 'rails_helper'

describe 'Merchant Potential API' do
  before(:each, :unshipped) do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)
    @customer = create(:customer)

    @invoice_1 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, status: 'pending')
    @invoice_2 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, status: 'pending')
    @invoice_3 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, status: 'pending')
    @invoice_4 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, status: 'pending')
    @invoice_5 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id, status: 'shipped')

    create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    create(:transaction, invoice_id: @invoice_2.id, result: 'success')
    create(:transaction, invoice_id: @invoice_3.id, result: 'success')
    create(:transaction, invoice_id: @invoice_4.id, result: 'success')
    create(:transaction, invoice_id: @invoice_5.id, result: 'success')

    create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 100.0)
    create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id, quantity: 50, unit_price: 100.0)
    create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id, quantity: 10, unit_price: 100.0)
    create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id, quantity: 20, unit_price: 100.0)
    create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id, quantity: 25, unit_price: 100.0)
  end

  describe '::Find revenue of single merchant' do
    describe '::Happy path' do
      it 'finds merchants with most revenue', :unshipped do
        x = 3
        get "/api/v1/revenue/unshipped?quantity=#{x}"

        expect(response).to be_successful
        expect(revenue[:data][0][:type]).to eq('unshipped_order')
        expect(revenue[:data][0][:attributes][:potential_revenue]).to eq("#{5000}")
        expect(revenue[:data][1][:attributes][:potential_revenue]).to eq("#{2000}")
        expect(revenue[:data][2][:attributes][:potential_revenue]).to eq("#{1000}")
      end
    end
    describe '::Sad path' do

    end
  end
end
