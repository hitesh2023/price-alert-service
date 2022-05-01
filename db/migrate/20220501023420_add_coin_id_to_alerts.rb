class AddCoinIdToAlerts < ActiveRecord::Migration[7.0]
  def change
    add_column :alerts, :coin_id, :string
  end
end
