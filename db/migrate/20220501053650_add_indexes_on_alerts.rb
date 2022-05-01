class AddIndexesOnAlerts < ActiveRecord::Migration[7.0]
  def change
    add_index :alerts, :status
  end
end
