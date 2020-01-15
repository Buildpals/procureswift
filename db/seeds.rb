# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#puts Order.all.count
#Order.all.each do |order|
#  puts order.id, order.cart_id
#  cart = Cart.create!(user: order.user)
#  cart.cart_items.build(product: order.product, quantity: order.quantity)
#  cart.save!
#  order.cart_id = cart.id
#  order.save!
#end

CartItem.all.each do |cart_item|
  puts "updating"
  cart_item.unit_price = cart_item.product.default_price
  cart_item.save!
end