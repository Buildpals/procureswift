class AddChosenOfferIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :chosen_offer_id, :string
  end
end
