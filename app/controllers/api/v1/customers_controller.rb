class Api::V1::CustomersController < ApplicationController
  def index
    render json: Customer.all
  end

  def show
    render json: Customer.find_by_id(params[:id])
  end
end
