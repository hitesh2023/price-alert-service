class AddIsDeletedColumnToAlerts < ActiveRecord::Migration[7.0]
  def change
    add_column :alerts, :is_deleted, :boolean, default: false
    add_index :alerts, :is_deleted
  end
end
