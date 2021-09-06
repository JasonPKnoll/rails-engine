require 'rails_helper'

describe "Transaction API" do
  it "sends a list of transactions" do
    create_list(:transaction, 3)

    get 'api/v1/transactions'

    expect(response).to be_successful
  end
end
