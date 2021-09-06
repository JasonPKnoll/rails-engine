require 'rails_helper'

describe "Customer API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get api_v1_customers_path
    require "pry"; binding.pry

    expect(response).to be_successful
  end
end
