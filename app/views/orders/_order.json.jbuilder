json.extract! order, :id, :product_id, :user_id, :chosen_offer_id, :quantity, :delivery_method, :full_name, :address, :region, :city_or_town, :phone_number, :email, :txtref, :status, :created_at, :updated_at
json.url order_url(order, format: :json)
