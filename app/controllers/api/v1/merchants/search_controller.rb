class Api::V1::Merchants::SearchController < ApplicationController

  def find
    merchant = Merchant.find_by_name(params[:name])
    if merchant.nil? or params[:name].nil?
      render json: {data: {}}
    else
    render json: MerchantSerializer.new(merchant)
    end
  end
end
