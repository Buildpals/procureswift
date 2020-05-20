class OrderBuilder
  US_SHIPPING_ADDRESS = {
    "first_name": "ProcureSwift",
    "last_name": "MyUS",
    "address_line1": "4283 Express Lane", 
    "address_line2": "Suite 5758-751",
    "zip_code": "34249",
    "city": "Sarasota",
    "state": "FL",
    "country": "US",
    "phone_number": "(941) 538-6941"
  }
  UK_SHIPPING_ADDRESSS = {
    "first_name": "Tim",
    "last_name": "Beaver",
    "address_line1": "77 Massachusetts Avenue",
    "address_line2": "",
    "zip_code": "02139",
    "city": "Cambridge",
    "state": "MA",
    "country": "US",
    "phone_number": "5551230101"
  }

  BILLING_ADDRESS = {
    "first_name": "Web Services -",
    "last_name": " ProcureSwift",
    "address_line1": "333 Fremont Street", 
    "address_line2": "",
    "zip_code": "94105",
    "city": "San Francisco",
    "state": "CA",
    "country": "US",
    "phone_number": ""
  }

  def initialize(order)
    @order = order
    @shipping_info = ShippingCalculator.new @order.cart
  end

  def get_request_body
    static_body = { 
      "max_price": @shipping_info.cost / ProductBuilder::CENTS_TO_DOLLARS_RATIO,
       "is_gift": true, 
       "gift_message": "Here is your package, Tim! Enjoy!",
       "shipping": {  
                        "order_by": "price",
                        "max_days": 5,
                        "max_price": 1000
                      }, 
      "payment_method": {  
                            "name_on_card": "Web Services - ProcureSwift",
                            "number": "4056401952976392",
                            "security_code": "345",
                            "expiration_month": 2,
                            "expiration_year": 2023,
                            "use_gift": false
                          },
   "retailer_credentials": {   
                               "email": "timbeaver@gmail.com",
                               "password": "myRetailerPassword",
                               "totp_2fa_key": "3DE4 3ERE 23WE WIKJ GRSQ VOBG CO3D METM 2NO2 OGUX Z7U4 DP2H UYMA" 
                              }, 
   "webhooks": {   
                  "request_succeeded": "http://mywebsite.com/zinc/request_succeeded",  
                  "request_failed": "http://mywebsite.com/zinc/requrest_failed",  
                  "tracking_obtained": "http://mywebsite.com/zinc/tracking_obtained" 
                 }, 
   "client_notes": {  
                        "our_internal_order_id": "abc123",
                        "any_other_field": ["any value"]
                      } 
    }

    amazon_products = []
    amazon_uk_products =[]
    @retailers[:amazon].each do |k,v|
      amazon_products << v
    end
    @retailers[:amazon_uk].each do |k,v|
      amazon_uk_products << v
    end
    amazon_order_hash = {
      "retailer": "amazon",
      "products": amazon_products,
      "shipping_address": US_SHIPPING_ADDRESS,
      "billing_address": BILLING_ADDRESS

    }
    amazon_uk_order_hash = {
      "retailer": "amazon_uk",
      "products": amazon_uk_products,
      "shipping_address": UK_SHIPPING_ADDRESSS,
      "billing_address": BILLING_ADDRESS
    }
    amazon_order_hash.merge!(static_body)
    amazon_uk_order_hash.merge!(static_body)
    [amazon_order_hash, amazon_uk_order_hash]
  end

  def get_retailers
    @retailers = Hash.new
    Product::RETAILERS.each_key do |key|
      @retailers[key] = {}
    end
    products = Hash.new
    i = 0
    @order.cart.cart_items.each do |item|
      i += 1
      item_hash = { 'product_id': Product.split_retailer_from_product_id(item.product_id)[1], 'quantity': item.quantity }
      products[i] = item_hash
      @retailers[item.retailer.to_sym].merge!(products)
    end
    puts @retailers
  end
end