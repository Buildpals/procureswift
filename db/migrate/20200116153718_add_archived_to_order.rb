class AddArchivedToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :archived, :boolean, default: false, null: false
  end
end
