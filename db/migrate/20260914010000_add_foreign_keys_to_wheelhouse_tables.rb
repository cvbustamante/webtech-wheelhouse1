class AddForeignKeysToWheelhouseTables < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :bikes, :bike_models
    add_index :bikes, :bike_model_id

    add_foreign_key :repairs, :bikes
    add_index :repairs, :bike_id

    add_foreign_key :repairs, :customers
    add_index :repairs, :customer_id

    add_foreign_key :repairs, :staff_members, column: :mechanic_id
    add_index :repairs, :mechanic_id

    add_foreign_key :repair_jobs, :repairs
    add_index :repair_jobs, :repair_id

    add_foreign_key :repair_jobs, :jobs
    add_index :repair_jobs, :job_id
  end
end
