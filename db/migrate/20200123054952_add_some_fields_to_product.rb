# frozen_string_literal: true

class AddSomeFieldsToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :title, :string
    add_column :products, :main_image, :string

    add_column :products, :offers, :json
    add_column :products, :price, :decimal, precision: 8, scale: 2

    add_column :products, :weight, :decimal, precision: 8, scale: 2
    add_column :products, :hs_code, :string

    add_column :products, :width, :decimal, precision: 8, scale: 2
    add_column :products, :length, :decimal, precision: 8, scale: 2
    add_column :products, :depth, :decimal, precision: 8, scale: 2
  end
end
