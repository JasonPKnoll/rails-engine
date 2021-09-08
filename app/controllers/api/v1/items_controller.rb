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

end
