class AddEmailAndReferenceNumberToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :email, :string
    add_column :orders, :txtref, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
