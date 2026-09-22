class RepairsController < ApplicationController
  def index
    @repairs = Repair.includes(:bike, :customer, :mechanic).by_promised_on
  end

  def show
    @repair = Repair.includes(:bike, :customer, :mechanic, repair_jobs: :job).find(params[:id])
  end
end
