class CreateRepairs < ActiveRecord::Migration[8.0]
  def change
    create_table :repairs do |t|
      t.bigint :bike_id, null: false
      t.bigint :customer_id, null: false
      t.bigint :mechanic_id, null: true
      t.string :status, null: false, default: "dropped_off"
      t.date :promised_on, null: false
      t.datetime :picked_up_at, null: true

      t.timestamps
    end
  end
end
