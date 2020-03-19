# frozen_string_literal: true

class DropProducts < ActiveRecord::Migration[6.0]
  def up
    drop_table :products
  end

  def down
    create_table 'products', force: :cascade do |t|
      t.string 'item_url'
      t.json 'zinc_product_details'
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.json 'zinc_product_offers'
      t.string 'chosen_offer_id'
      t.boolean 'featured', default: false, null: false
      t.string 'title'
      t.string 'main_image'
      t.json 'offers'
      t.decimal 'price', precision: 8, scale: 2
      t.decimal 'weight', precision: 8, scale: 2
      t.string 'hs_code'
      t.decimal 'width', precision: 8, scale: 2
      t.decimal 'length', precision: 8, scale: 2
      t.decimal 'depth', precision: 8, scale: 2
    end
  end
end
