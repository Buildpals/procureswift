class CreateNewOrdersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :product, foreign_key: true
      t.references :user, foreign_key: true
      t.string :chosen_offer_id
      t.integer :quantity
      t.integer :delivery_method, default: 0, null: false
      t.string :full_name
      t.string :address
      t.integer :region, default: 0, null: false
      t.string :city_or_town
      t.string :phone_number
      t.string :email
      t.string :txtref
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
