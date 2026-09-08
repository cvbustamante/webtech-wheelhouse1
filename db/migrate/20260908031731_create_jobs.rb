class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :name, null: false
      t.decimal :price, precision: 8, scale: 2, null: false

      t.timestamps
    end
    add_index :jobs, :name, unique: true
  end
end
