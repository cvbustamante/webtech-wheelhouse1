class CreateRepairJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :repair_jobs do |t|
      t.bigint :repair_id, null: false
      t.bigint :job_id, null: false
      t.decimal :price_charged, precision: 8, scale: 2, null: false

      t.timestamps
    end
  end
end
