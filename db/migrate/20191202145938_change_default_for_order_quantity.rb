class ChangeDefaultForOrderQuantity < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :quantity, :integer, default: 1, null: false
  end
end
