class BikesController < ApplicationController
  def index
    @bikes = Bike.includes(:bike_model).by_serial_number
  end

  def show
    @bike = Bike.includes(:bike_model, repairs: [:customer, :mechanic]).find(params[:id])
  end
end
