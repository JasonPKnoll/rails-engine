require 'rails_helper'

describe "Merchant Items API" do
  it "grabs all merchant items" do
    merchant_id = create(:merchant).id
    merchant_id_2 = create(:merchant).id
    create_list(:item, 3, merchant_id: merchant_id)
    create_list(:item, 1, merchant_id: merchant_id_2)

    get "/api/v1/merchants/#{merchant_id}/items"

    merchant_items = JSON.parse(response.body, symbolize_names: true)
    expect(merchant_items[:data].count).to eq(3)
  end

  it "returns 404 when no merchant found" do
    merchant_id = 1

    get "/api/v1/merchants/#{merchant_id}/items"
    
    expect(response.status).to eq(404)
  end
end
