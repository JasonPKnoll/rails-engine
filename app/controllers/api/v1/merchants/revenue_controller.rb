class Api::V1::Merchants::RevenueController < ApplicationController

  def merchant_total_revenue
    merchant = Merchant.find_by_id(params[:id])
    render json: merchant.find_merchant_rev
  end

  def most_revenue_merchants
    if params[:quantity].to_i >= 1
      merchants = Merchant.find_most_revenue(params[:quantity])
      render json: MerchantRevenueSerializer.new(merchants)
    else
      render json: {error: ["Quantity must be greater than 0"]}, status: 400
    end
  end

end
