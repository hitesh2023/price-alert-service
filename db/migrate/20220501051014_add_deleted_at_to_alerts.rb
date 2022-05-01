class AddDeletedAtToAlerts < ActiveRecord::Migration[7.0]
  def change
    add_column :alerts, :deleted_at, :datetime
    add_index :alerts, :deleted_at
  end
end
