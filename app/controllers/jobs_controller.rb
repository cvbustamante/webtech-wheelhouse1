class JobsController < ApplicationController
  def index
    @jobs = Job.order(:name)
  end

  def show
    @job = Job.find(params[:id])
  end
end
