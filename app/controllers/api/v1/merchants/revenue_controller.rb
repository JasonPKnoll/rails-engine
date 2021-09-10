class Api::V1::Merchants::RevenueController < ApplicationController

  def merchant_total_revenue
    merchant = Merchant.find_by_id(params[:id])
    if params[:id].nil? or merchant.nil?
      record_not_found
    else
      merchant = Merchant.find_merchant_rev(params[:id])
      render json: MerchantRevenueSerializer.new(merchant)
    end
  end

  def most_revenue_merchants
    if params[:quantity].to_i >= 1
      merchants = Merchant.find_most_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    else
      render json: {error: ["Quantity must be greater than 0"]}, status: 400
    end
  end

  def unshipped
    if params[:quantity].nil?
      merchants = Merchant.total_potential_revenue(10)
      render json: UnshippedOrderSerializer.new(merchants)
    elsif params[:quantity].to_i >= 1
      merchants = Merchant.total_potential_revenue(params[:quantity])
      render json: UnshippedOrderSerializer.new(merchants)
    else
      render json: {error: ["Quantity must be greater than 0"]}, status: 400
    end
  end
end
