class AddAddressToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :address, :string
    add_column :orders, :city_or_town, :string
  end
end
