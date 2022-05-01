class RemoveColumnIsDeletedFromAlerts < ActiveRecord::Migration[7.0]
  def change
    remove_column :alerts, :is_deleted
  end
end
