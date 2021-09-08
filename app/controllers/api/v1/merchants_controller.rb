class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.limit(per_page).offset(page)
    render json: MerchantSerializer.new(merchants)
    # render json: merchants
  end

  def show
    merchant = Merchant.find_by_id(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def page
    min_page_number = 1
    ([params.fetch(:page, min_page_number).to_i, min_page_number].max - min_page_number) * per_page
  end

  def per_page
    default = 20
    [ params.fetch(:per_page, default).to_i, default ].max  #fetch allows us to manually a limit if fetch request comes back as NIL
  end
end
