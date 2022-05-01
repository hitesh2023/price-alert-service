class AddPriceToAlerts < ActiveRecord::Migration[7.0]
  def change
    add_column :alerts, :user_id, :integer
    add_column :alerts, :price, :float
    add_column :alerts, :status, :integer, default: 0
  end
end
