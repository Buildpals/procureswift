class AddApiHashToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :api_hash, :text, array: true
  end
end
