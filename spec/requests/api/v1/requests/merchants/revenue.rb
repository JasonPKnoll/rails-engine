require 'rails_helper'

describe "Merchant Reve API" do
  before(:each, :with_merchants_rev) do
    @merchant = create(:merchant)
  end
  describe "::Find revenue of single merchant" do
    describe "::Happy path" do
      it "finds the merchants revenue", :with_merchants do

        get "api/v1/revenue/merchants/#{@merchant.id}" #, params: { search: "Find" }

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchants[:data][:attributes][:name]).to eq([])
      end
    end
    describe "::Sad Path" do
      it "error", :with_merchants_rev do

    end
  end
end
