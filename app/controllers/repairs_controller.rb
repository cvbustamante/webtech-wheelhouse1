class RepairsController < ApplicationController
  before_action :set_repair, only: [:show, :edit, :update, :destroy]

  def index
    @repairs = Repair.includes(:bike, :customer, :mechanic, :rich_text_diagnosis,
      intake_photos_attachments: { blob: :variant_records }).by_promised_on
  end

  def show
  end

  def new
    @repair = Repair.new(bike_id: params[:bike_id])
    add_blank_lines
  end

  def create
    @repair = Repair.new(repair_params.except(:intake_photos))
    @repair.intake_photos = new_intake_photos if new_intake_photos.any?
    if @repair.save
      redirect_to @repair, notice: "Repair for #{@repair.bike.serial_number} was created."
    else
      add_blank_lines
      render :new, status: :unprocessable_content
    end
  end

  def edit
    add_blank_lines
  end

  def update
    @repair.assign_attributes(repair_params.except(:intake_photos))
    if new_intake_photos.any?
      @repair.intake_photos = @repair.intake_photos.map(&:blob) + new_intake_photos
    end
    if @repair.save
      redirect_to @repair, notice: "Repair for #{@repair.bike.serial_number} was updated."
    else
      add_blank_lines
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @repair.destroy
      redirect_to repairs_path, status: :see_other, notice: "Repair for #{@repair.bike.serial_number} was deleted."
    else
      redirect_to @repair, status: :see_other, alert: @repair.errors.full_messages.to_sentence
    end
  end

  private

  def set_repair
    @repair = Repair.includes(:bike, :customer, :mechanic, :rich_text_diagnosis,
      repair_jobs: :job, intake_photos_attachments: { blob: :variant_records }).find(params[:id])
  end

  # una repair puede tener hasta 4 repair_jobs, asi que siempre ofrecemos
  # lineas en blanco hasta llegar a 4, sin necesitar JS para agregar mas
  def add_blank_lines
    (4 - @repair.repair_jobs.size).times { @repair.repair_jobs.build }
  end

  def repair_params
    params.expect(repair: [
      :bike_id, :customer_id, :mechanic_id, :status, :promised_on, :picked_up_at, :diagnosis,
      intake_photos: [],
      repair_jobs_attributes: [[:id, :job_id, :price_charged, :_destroy]]
    ])
  end

  def new_intake_photos
    Array(repair_params[:intake_photos]).reject(&:blank?)
  end
end
