class RenamePurchasedInOrders < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :purchased, :bought
  end
end
