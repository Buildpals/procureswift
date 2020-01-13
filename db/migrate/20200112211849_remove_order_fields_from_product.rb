# frozen_string_literal: true

class RemoveOrderFieldsFromProduct < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :item_quantity
    remove_column :products, :delivery_method
    remove_column :products, :delivery_region
    remove_column :products, :full_name
    remove_column :products, :phone_number
    remove_column :products, :email
    remove_column :products, :txtref
    remove_column :products, :status
    remove_column :products, :address
    remove_column :products, :city_or_town
  end
end
