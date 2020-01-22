class RemoveBoughtFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :bought, :boolean, default: false, null: false
  end
end
