# frozen_string_literal: true

require 'rails_helper'

describe 'Merchant search API' do
  before(:each, :with_merchants) do
    @merchant = create(:merchant, name: 'Find Me Please')
    create_list(:merchant, 10)
  end
  describe '::Find by name' do
    describe '::Happy path' do
      it 'finds the merchant by name', :with_merchants do
        search = 'find'
        get "/api/v1/merchants/find?name=#{search}" # , params: { search: "Find" }

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchants[:data][:attributes][:name]).to eq(@merchant.name)
      end
    end
    describe '::Sad Path' do
      it 'gives error when finding no merchant', :with_merchants do
        get '/api/v1/merchants/find?name=lovesick'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_an(Object)
        expect(response.body).to include('data')
      end
    end
  end
end
