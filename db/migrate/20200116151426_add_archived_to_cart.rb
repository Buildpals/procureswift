class AddArchivedToCart < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :archived, :boolean, default: false, null: false
  end
end
