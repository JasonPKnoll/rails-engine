class Api::V1::Items::SearchController < ApplicationController

  def find_all
    items = Item.find_all_by_name(params[:name])
    if items.nil?
      render json: { :data => ["No items found for #{params[:name]}"]}
    else
      render json: ItemSerializer.new(items)
    end
  end
end
