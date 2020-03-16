class AddPurchasedAtToCart < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :purchased_at, :datetime
  end
end
