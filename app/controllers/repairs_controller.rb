class RepairsController < ApplicationController
  def index
    # las mas urgentes primero, no por id
    @repairs = Repair.order(:promised_on)
  end

  def show
    @repair = Repair.find(params[:id])
  end
end
