class Api::V1::Merchants::SearchController < ApplicationController

  def find
    merchant = Merchant.find_by_name(params[:name])
    if merchant.nil?
      render json: {"error" => "null"}, status: 404
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
