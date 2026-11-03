class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    # mechanic es el rol con menos permisos, ver docs/decisions.md
    add_column :users, :role, :string, null: false, default: "mechanic"
  end
end
