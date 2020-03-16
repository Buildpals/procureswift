class RemoveUnnecessaryFieldsFromOrder < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :delivery_method, :integer, default: 0, null: false
    remove_column :orders, :region, :integer, default: 0, null: false
    remove_column :orders, :full_name
    remove_column :orders, :address
    remove_column :orders, :city_or_town
    remove_column :orders, :phone_number
    remove_column :orders, :email
  end
end
