json.extract! order, :id, :item_url, :item_quantity, :delivery_method, :delivery_region, :zinc_product_details, :full_name, :phone_number, :created_at, :updated_at
json.url order_url(order, format: :json)
