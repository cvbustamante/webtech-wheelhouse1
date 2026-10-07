class IntakePhotosController < ApplicationController
  def destroy
    repair = Repair.find(params[:repair_id])
    photo = repair.intake_photos_attachments.find(params[:id])
    photo.purge
    redirect_to repair, status: :see_other, notice: "Photo was deleted."
  end
end
