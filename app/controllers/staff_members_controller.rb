class StaffMembersController < ApplicationController
  def index
    @staff_members = StaffMember.by_name
  end

  def show
    @staff_member = StaffMember.includes(repairs: [:bike, :customer, :mechanic]).find(params[:id])
  end
end
