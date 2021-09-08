require 'rails_helper'

describe "Merchant API" do
  it "sends a subset of merchants based on pagination" do
    create_list(:merchant, 22)

    get api_v1_merchants_path, params: { per_page: 20, page: 0 }

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchants[:data].count).to eq(20)
  end

  it 'can grab the second page of merchants' do
    create(:merchant, name: "not_a_real_name")
    create_list(:merchant, 18)
    create(:merchant, name: "not_a_real_name_2")
    create(:merchant, name: "not_a_real_name_3")
    create_list(:merchant, 18)
    create(:merchant, name: "not_a_real_name_4")

    get api_v1_merchants_path, params: { per_page: 20, page: 2 }

    merchants = JSON.parse(response.body, symbolize_names: true)
    merchant_names = merchants[:data].map do |merchant|
      merchant[:attributes][:name]
    end

    expect(response).to be_successful
    expect(merchants[:data].count).to eq(20)

    expect(merchant_names).to include("not_a_real_name_3")
    expect(merchant_names).to include("not_a_real_name_4")

    expect(merchant_names).to_not include("not_a_real_name_1")
    expect(merchant_names).to_not include("not_a_real_name_2")
  end

  xit "can return more than the default 20 merchants" do
    expect(Merchant).to receive(:per_page).with(100).and_call_original

    get api_v1_merchants_path, params: { per_page: 100 }
  end

  it "can return specified amount all merchants if per_page is big" do
    create_list(:merchant, 22)

    get api_v1_merchants_path, params: { per_page: 100 }

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(22)
  end

  it "can grab a merchant by that merchants id" do
    id = create(:merchant).id
    id_2 = create(:merchant).id

    get api_v1_merchant_path(id)

    expect(response).to be_successful

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["id"]).to eq("#{id}")
    expect(merchant["data"]["id"]).to_not eq("#{id_2}")
  end
end
