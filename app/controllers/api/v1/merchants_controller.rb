class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.limit(params[:limit]).offset(params[:offset])
    render json: MerchantSerializer.new(merchants)
    # render json: merchants
  end

  def show
    merchant = Merchant.find_by_id(params[:id])
    render json: MerchantSerializer.format_merchants(merchant)
  end

  def grab_merchants(page, per_each_page)
    require "pry"; binding.pry
    Merchant.all
  end
end
