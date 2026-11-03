class AddStaffMemberToUsers < ActiveRecord::Migration[8.0]
  def change
    # una cuenta puede no tener staff, pero un staff tiene a lo mas una cuenta
    add_reference :users, :staff_member, foreign_key: true, index: { unique: true }
  end
end
