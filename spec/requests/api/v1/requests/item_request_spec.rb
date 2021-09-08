require 'rails_helper'

describe "Item API" do
  before(:each, :with_many_items) do
    merchant_id = create(:merchant).id
    create(:item, merchant_id: merchant_id, name: "not_a_real_item_1")
    create_list(:item, 18, merchant_id: merchant_id)
    create(:item, merchant_id: merchant_id, name: "not_a_real_item_2")
    create(:item, merchant_id: merchant_id, name: "not_a_real_item_3")
    create_list(:item, 18, merchant_id: merchant_id)
    create(:item, merchant_id: merchant_id, name: "not_a_real_item_4")
  end

  before(:each, :with_items) do
    merchant_id = create(:merchant).id
    merchant_id_2 = create(:merchant).id
    create_list(:item, 5, merchant_id: merchant_id)
    create_list(:item, 5, merchant_id: merchant_id_2)
  end

  describe ":: grab items" do
    describe ":: happy paths" do
      it "can return all items", :with_items do
        get api_v1_items_path

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(items[:data].count).to eq(10)
      end

      it "default returns 20 items", :with_many_items do
        get api_v1_items_path

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(items[:data].count).to eq(20)
      end

      it "can return more than 20 at a time", :with_many_items do
        get api_v1_items_path, params: { per_page: 25 }

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(items[:data].count).to eq(25)
      end
    end

    describe ":: sad path" do
      it "page 0 or lower results as if page 1", :with_many_items do
        get api_v1_items_path, params: { page: 0 }

        items = JSON.parse(response.body, symbolize_names: true)

        item_names = items[:data].map { |item| item[:attributes][:name] }

        expect(items[:data].count).to eq(20)
        expect(item_names).to include("not_a_real_item_2")
        expect(item_names).to_not include("not_a_real_item_3")

        get api_v1_items_path, params: { page: -3 }

        items = JSON.parse(response.body, symbolize_names: true)

        item_names = items[:data].map { |item| item[:attributes][:name] }

        expect(items[:data].count).to eq(20)
        expect(item_names).to include("not_a_real_item_2")
        expect(item_names).to_not include("not_a_real_item_3")
      end
    end

  end
end
