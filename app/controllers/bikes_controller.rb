class BikesController < ApplicationController
  before_action :set_bike, only: [:show, :edit, :update, :destroy]

  def index
    @bikes = Bike.includes(:bike_model).by_serial_number
  end

  def show
  end

  def new
    @bike = Bike.new(customer_id: params[:customer_id])
  end

  def create
    @bike = Bike.new(bike_params)
    if @bike.save
      redirect_to @bike, notice: "#{@bike.serial_number} was created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @bike.update(bike_params)
      redirect_to @bike, notice: "#{@bike.serial_number} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @bike.destroy
      redirect_to bikes_path, status: :see_other, notice: "#{@bike.serial_number} was deleted."
    else
      redirect_to @bike, status: :see_other, alert: @bike.errors.full_messages.to_sentence
    end
  end

  private

  def set_bike
    @bike = Bike.includes(:bike_model, :customer, repairs: [:customer, :mechanic]).find(params[:id])
  end

  def bike_params
    params.expect(bike: [:bike_model_id, :customer_id, :serial_number])
  end
end
