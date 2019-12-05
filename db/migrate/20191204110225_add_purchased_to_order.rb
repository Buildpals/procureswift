class AddPurchasedToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :purchased, :boolean, null: false, default: false
  end
end
