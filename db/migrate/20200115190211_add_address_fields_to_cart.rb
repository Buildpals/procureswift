class AddAddressFieldsToCart < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :full_name, :string
    add_column :carts, :address, :string
    add_column :carts, :region, :integer, default: 0, null: false
    add_column :carts, :city_or_town, :string
    add_column :carts, :phone_number, :string
    add_column :carts, :delivery_method, :integer, default: 0, null: false
  end
end
