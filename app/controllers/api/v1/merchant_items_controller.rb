class Api::V1::MerchantItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    merchant = Merchant.find_by_id(params[:merchant_id])
    if merchant.equal?(nil)
      record_not_found
    else
      render json: ItemSerializer.new(merchant.items)
    end
  end

  private

  def record_not_found
    render json: {"error" => "404 Not Found"}, status: 404
  end

end
