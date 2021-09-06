require 'rails_helper'

describe "Invoice API" do
  it "sends a list of invoice" do
    create_list(:invoice, 3)

    get 'api/v1/invoices'

    expect(response).to be_successful
  end
end
