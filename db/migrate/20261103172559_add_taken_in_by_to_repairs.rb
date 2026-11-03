class AddTakenInByToRepairs < ActiveRecord::Migration[8.0]
  def change
    # la cuenta que recibio la bike. las repairs de antes de este lab quedan en null
    add_reference :repairs, :taken_in_by, foreign_key: { to_table: :users }
  end
end
