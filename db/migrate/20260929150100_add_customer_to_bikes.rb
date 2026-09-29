class AddCustomerToBikes < ActiveRecord::Migration[8.0]
  def up
    add_reference :bikes, :customer, foreign_key: true

    # bikes de antes de este lab no tenian owner: le asignamos el customer de
    # su repair mas antigua, y si una bike todavia no tiene ninguna repair
    # (le paso a una del seed) la dejamos con el customer mas antiguo
    Bike.reset_column_information
    Bike.find_each do |bike|
      owner_id = bike.repairs.order(:created_at).first&.customer_id
      owner_id ||= Customer.order(:created_at).first&.id
      bike.update_column(:customer_id, owner_id)
    end

    change_column_null :bikes, :customer_id, false
  end

  def down
    remove_reference :bikes, :customer, foreign_key: true
  end
end
