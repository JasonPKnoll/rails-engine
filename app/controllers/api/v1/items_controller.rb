class Api::V1::ItemsController < ApplicationController

  def index
    items = Item.limit(per_page).offset(page)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find_by_id(params[:id])
    if item.nil?
      record_not_found
    else
      render json: ItemSerializer.new(item)
    end
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status:201
  end


  def update
    if params[:id].nil?
      record_not_found
    else
      item = Item.find_by_id(params[:id])
      if item.nil?
        record_not_found
      else
      # merchant = Merchant.find_by_id(item.merchant_id)
        item = Item.update(params[:id], item_params)
        render json: ItemSerializer.new(item), status: 200
      end
    end
  end

  def destroy
    Item.delete(params[:id])
  end

  def find_merchant
    item = Item.find_by_id(params[:item_id])
    merchant = Merchant.find_by_id(item.merchant_id)
    render json: MerchantSerializer.new(merchant)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
