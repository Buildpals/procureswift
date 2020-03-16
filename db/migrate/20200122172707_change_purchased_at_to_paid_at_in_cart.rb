class ChangePurchasedAtToPaidAtInCart < ActiveRecord::Migration[6.0]
  def change
    rename_column :carts, :purchased_at, :paid_at
  end
end
