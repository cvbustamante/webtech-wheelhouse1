class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: [:show, :edit, :update, :destroy]

  def index
    authorize StaffMember
    @staff_members = policy_scope(StaffMember).by_name
  end

  def show
    authorize @staff_member
    # las repairs de este staff, pero solo las que la cuenta puede leer
    @repairs = policy_scope(Repair).where(mechanic: @staff_member)
      .includes(:bike, :customer, :mechanic, :rich_text_diagnosis, { taken_in_by: :staff_member },
        intake_photos_attachments: { blob: :variant_records })
      .by_promised_on.load
  end

  def new
    @staff_member = StaffMember.new
    authorize @staff_member
  end

  def create
    @staff_member = StaffMember.new(staff_member_params)
    authorize @staff_member
    if @staff_member.save
      redirect_to @staff_member, notice: "#{@staff_member.name} was created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @staff_member
  end

  def update
    authorize @staff_member
    if @staff_member.update(staff_member_params)
      redirect_to @staff_member, notice: "#{@staff_member.name} was updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @staff_member
    if @staff_member.destroy
      redirect_to staff_members_path, status: :see_other, notice: "#{@staff_member.name} was deleted."
    else
      redirect_to @staff_member, status: :see_other, alert: @staff_member.errors.full_messages.to_sentence
    end
  end

  private

  def set_staff_member
    @staff_member = StaffMember.find(params[:id])
  end

  def staff_member_params
    params.expect(staff_member: [:name, :role])
  end
end
