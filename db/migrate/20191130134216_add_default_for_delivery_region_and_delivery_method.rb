class AddDefaultForDeliveryRegionAndDeliveryMethod < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :delivery_method, :integer, default: 0
    change_column :orders, :delivery_region, :integer, default: 0
    change_column :orders, :status, :integer, default: 0
  end
end
