# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
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

    @invoice_1 = create(:invoice, merchant_id: @merchant_1.id, customer_id: @customer.id, status: 'packaged')
    @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer.id, status: 'packaged')
    @invoice_3 = create(:invoice, merchant_id: @merchant_3.id, customer_id: @customer.id, status: 'shipped')
    @invoice_4 = create(:invoice, merchant_id: @merchant_4.id, customer_id: @customer.id, status: 'packaged')

    create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    create(:transaction, invoice_id: @invoice_2.id, result: 'success')
    create(:transaction, invoice_id: @invoice_3.id, result: 'success')
    create(:transaction, invoice_id: @invoice_4.id, result: 'success')

    create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 100.0)
    create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 55, unit_price: 100.0)
    create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 10, unit_price: 100.0)
    create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_4.id, quantity: 25, unit_price: 100.0)
  end

  it '::total_potential_revenue finds the revenue of unshipped orders', :with_multi_merchants_rev do
    expect(Invoice.potential_revenue(3)).to eq([@invoice_2, @invoice_4, @invoice_1])
  end
end
