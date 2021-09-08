class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.limit(per_page).offset(page)
    render json: MerchantSerializer.new(merchants)
    # render json: merchants
  end

  def show
    merchant = Merchant.find_by_id(params[:id])
    if merchant.equal?(nil)
      record_not_found
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
