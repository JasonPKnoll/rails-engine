require 'rails_helper'

describe "Invoice Items API" do
  it "sends a list of invoice items" do
    create_list(:invoice_item, 3)

    get 'api/v1/invoice_items'

    expect(response).to be_successful
  end
end
