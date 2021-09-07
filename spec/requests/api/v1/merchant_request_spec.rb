require 'rails_helper'

describe "Merchant API" do
  it "sends a subset of merchants based on pagination" do
    create_list(:merchant, 40)

    get api_v1_merchants_path, params: { limit: 20, offset: 1 }

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchants[:data].count).to eq(20)
  end

  it "can grab a merchant by that merchants id" do
    id = create(:merchant).id

    get api_v1_merchant_path(id)

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["id"]).to eq(id)
  end
end
