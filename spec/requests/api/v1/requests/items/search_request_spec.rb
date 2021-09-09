require 'rails_helper'

describe "items search API" do
  before(:each, :with_specific_items) do
    merchant = create(:merchant)
    @item_1 = create(:item, name: "strawberry donut", merchant_id: merchant.id)
    @item_2 = create(:item, name: "bagel", merchant_id: merchant.id)
    @item_3 = create(:item, name: "glazed donut", merchant_id: merchant.id)
  end
  describe "finds all items by name" do
    describe "::Happy Paths" do
      it "finds an Item by name", :with_specific_items do
        search = "donu"
        get "/api/v1/items/find_all?name=#{search}"

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(items[:data][0][:attributes][:name]).to eq("#{@item_3.name}")
        expect(items[:data][1][:attributes][:name]).to eq("#{@item_1.name}")
      end
    end
    describe "::Sad Paths" do
      it "gives an error with empty data" do
        search = "donu"
        get "/api/v1/items/find_all?name=#{search}"

        items = JSON.parse(response.body, symbolize_names: true)


        expect(response).to be_successful
        expect(response.body).to include("data")
      end
    end
  end
end
