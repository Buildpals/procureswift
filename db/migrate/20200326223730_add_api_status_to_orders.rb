class AddApiStatusToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :api_status, :integer
  end
end
