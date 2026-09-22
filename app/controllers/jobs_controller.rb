class JobsController < ApplicationController
  def index
    @jobs = Job.by_name
  end

  def show
    @job = Job.find(params[:id])
  end
end
