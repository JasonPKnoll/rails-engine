# frozen_string_literal: true

require 'rails_helper'

describe 'Customer API' do
  it 'sends a list of customers' do
    create_list(:customer, 3)

    get api_v1_customers_path

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers.count).to eq(3)
  end

  it 'can get one item by its id' do
    id = create(:customer).id

    get api_v1_customer_path(id)

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer['id']).to eq(id)
  end
end
