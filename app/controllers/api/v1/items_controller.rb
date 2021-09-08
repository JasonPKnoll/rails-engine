class Api::V1::ItemsController < ApplicationController

  def index
    items = Item.limit(per_page).offset(page)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find_by_id(params[:id])
    if item.equal?(nil)
      record_not_found
    else
      render json: ItemSerializer.new(item)
    end
  end

  def create
    render json: Item.create(item_params)
  end

  def update
    render json: Item.update(params[:id], item_params)
  end

  def destroy
    Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
