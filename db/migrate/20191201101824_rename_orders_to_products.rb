class RenameOrdersToProducts < ActiveRecord::Migration[6.0]
  def change
    rename_table :orders, :products
  end
end
