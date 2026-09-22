class CustomersController < ApplicationController
  def index
    @customers = Customer.by_name
  end

  def show
    @customer = Customer.includes(bikes: :bike_model).find(params[:id])
  end
end
