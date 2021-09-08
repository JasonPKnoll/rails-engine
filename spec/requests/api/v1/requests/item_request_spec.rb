require 'rails_helper'

describe "Item API" do
  before(:each, :with_one_item) do
    @merchant = create(:merchant)
    @item = create(:item, merchant_id: @merchant.id)
  end

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
    create_list(:item, 2, merchant_id: merchant_id)
    create_list(:item, 3, merchant_id: merchant_id_2)
  end

  describe ":: grab items" do
    describe ":: happy paths" do
      it "can return all items", :with_items do
        get api_v1_items_path

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(items[:data].count).to eq(5)
      end

      it "can return one item by id", :with_one_item do
        get api_v1_item_path(@item)
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item.count).to eq(1)
        expect(item[:data][:id]).to eq("#{@item.id}")
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
      it "404s with invalid item id" do
        get api_v1_item_path(1)

        expect(response.status).to eq(404)
      end

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

  describe "can create items" do
    describe ":: happy paths" do
      it "creates an item" do
        merchant_id = create(:merchant).id
        item_params = {name: "generic item", description: "it does the thing", unit_price: 100.0, merchant_id: merchant_id}

        post '/api/v1/items', params: {item: item_params}
        item = Item.last

        expect(response).to be_successful
        expect(item.name).to eq(item_params[:name])
      end
    end
  end

  describe "can manipulate items" do
    describe ":: happy paths" do
      it "updates an item", :with_one_item do
        previous_name = @item.name
        item_params = {name: "Big Chungus"}

        put "/api/v1/items/#{@item.id}", params: {item: item_params}
        updated_item = Item.last

        expect(response).to be_successful
        expect(updated_item.name).to_not eq(previous_name)
        expect(updated_item.name).to eq(item_params[:name])
      end

      it "can destroy an item", :with_one_item do
        expect(Item.count).to eq(1)

        delete "/api/v1/items/#{@item.id}"

        expect(response).to be_successful
        expect(Item.count).to eq(0)
      end
    end
  end

  describe "can grab merchant by item id" do
    describe ":: happy path" do
      it "gets merchant by item id", :with_one_item do

        get "/api/v1/items/#{@item.id}/merchant"
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchant[:data][:id]).to eq("#{@merchant.id}")
      end
    end
  end
end
