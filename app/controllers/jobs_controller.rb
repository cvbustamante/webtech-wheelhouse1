class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = Job.by_name
  end

  def show
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to @job, notice: "#{@job.name} was created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: "#{@job.name} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @job.destroy
      redirect_to jobs_path, status: :see_other, notice: "#{@job.name} was deleted."
    else
      redirect_to @job, status: :see_other, alert: @job.errors.full_messages.to_sentence
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.expect(job: [:name, :price])
  end
end
