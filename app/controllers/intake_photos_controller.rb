class IntakePhotosController < ApplicationController
  def destroy
    repair = Repair.find(params[:repair_id])
    # sacar una foto es editar la repair, asi que pregunta lo mismo que el edit
    authorize repair, :update?
    photo = repair.intake_photos_attachments.find(params[:id])
    photo.purge
    redirect_to repair, status: :see_other, notice: "Photo was deleted."
  end
end
