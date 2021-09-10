class Api::V1::Items::RevenueController < ApplicationController

  def most_revenue_items
    if params[:quantity].nil?
      items = Item.find_most_revenue(10)
      render json: ItemRevenueSerializer.new(items)
    elsif params[:quantity].to_i >= 1
      items = Item.find_most_revenue(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    else
      render json: {error: ["Quantity must be greater than 0"]}, status: 400
    end
  end

end
