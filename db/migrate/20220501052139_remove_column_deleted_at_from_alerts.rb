class RemoveColumnDeletedAtFromAlerts < ActiveRecord::Migration[7.0]
  def change
    remove_column :alerts, :deleted_at
  end
end
