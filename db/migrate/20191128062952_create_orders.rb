class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :item_url
      t.integer :item_quantity
      t.integer :delivery_method
      t.integer :delivery_region
      t.json :zinc_product_details
      t.string :full_name
      t.string :phone_number

      t.timestamps
    end
  end
end
